class HydrateQuery

  def initialize(model, context, order_by: nil, filter: nil, check_visibility: true, id: nil, user: nil, page: nil, per_page: nil)
    @context = context
    @filter = filter
    @order_by = order_by
    @model = model
    @models = [model_name.singularize.camelize]
    @check_visibility = check_visibility
    @id = id
    @user = user
    @page = page
    @per_page = per_page
  end

  def run
    if @id
      @model = @model.where(id: @id)
      deep_pluck_to_structs(@context&.irep_node).first
    else
      filter_and_order
      deep_pluck_to_structs(@context&.irep_node)
    end
  end

  def paginated_run
    filter_and_order

    @total = @model.visible_for(user: @user).count
    @model = @model.limit(@per_page)
    @model = @model.offset(@per_page * (@page - 1))

    Rails.logger.info(@model.to_sql)
    OpenStruct.new(
      data: deep_pluck_to_structs(@context&.irep_node&.typed_children&.values&.first.try(:[], 'data')),
      total_count: @total,
      per_page: @per_page,
      page: @page
    )
  end

  private

  def filter_and_order
    @model = @model.where(transform_filter(@filter)) if @filter
    return unless @order_by

    @model = @model.order(@order_by)

    # sign = @order_by.split(' ').last.downcase == 'desc' ? 'desc' : 'asc'
    # column = @order_by.split(' ').first
    # if column.include?('.')
    #   @model = @model.left_joins(column.split('.').first.to_sym)
    #   string_type = %i[string text].include?(
    #     evaluate_model(@model, column.split('.').first).columns_hash[column.split('.').last]&.type
    #   )
    #   column = "#{column.split('.').first.pluralize}.#{column.split('.').last}"
    #   @model = @model.order(Arel.sql("#{string_type ? "upper(#{column})" : column} #{sign}"))
    # elsif @order_by
    #   return @model = @model.order("#{column}::float #{sign}") if %w[price commission qty income].include?(column)

    #   order = @model.arel_table[column]
    #   order = order.lower if %i[string text].include?(@model.columns_hash[column]&.type)

    #   @model = @model.order(order.send(sign))
    # end
  end

  def transform_filter(filter)
    parsed_filter = RKelly::Parser.new.parse(filter.gsub('like', ' | ')).to_ecma
    @model.klass.defined_enums.values.reduce(:merge)&.each { |k, v| parsed_filter.gsub!(" #{k}", " #{v}") }
    parsed_filter.gsub(' | ', ' ilike ').gsub('||', 'OR').gsub('&&', 'AND').gsub('===', '=').gsub('==', '=').gsub(
      '!= null', 'IS NOT NULL'
    ).gsub('= null', 'IS NULL').delete(';')
  end

  def deep_pluck_to_structs(irep_node)
    plucked_attr_to_structs(
      DeepPluck::Model.new(@model.visible_for(user: @user), user: @user).add(
        hash_to_array_of_hashes(parse_fields(irep_node), @model)
      ).load_all,
      model_name.singularize.camelize.constantize
    )&.compact
  end

  def plucked_attr_to_structs(arr, parent_model)
    arr.map { |e| hash_to_struct(e, parent_model) }
  end

  def hash_to_struct(hash, parent_model)
    hash.each_with_object(OpenStruct.new) do |(k, v), struct|
      m = evaluate_model(parent_model, k)

      next struct[k.to_sym] = plucked_attr_to_structs(v, m) if v.is_a?(Array) && m

      next struct[k.to_sym] = hash_to_struct(v, m) if v.is_a?(Hash) && m

      struct[k.to_sym] = v
    end
  end

  def hash_to_array_of_hashes(hash, parent_class)
    return if parent_class.nil? || hash.nil?

    hash['id'] = nil if hash['id'].blank?
    fetch_ids_from_relation(hash)

    hash.each_with_object([]) do |(k, v), arr|
      next arr << k if parent_class.new.attributes.key?(k)
      next arr << v if parent_class.new.attributes.key?(v)

      klass = evaluate_model(parent_class, k)
      @models << klass.to_s unless @models.include?(klass.to_s)
      arr << { k.to_sym => hash_to_array_of_hashes(v, klass) } if klass.present? && v.present?
    end
  end

  def fetch_ids_from_relation(hash)
    hash.select { |k, _| k.ends_with?('_ids') }.each do |(k, _)|
      collection_name = k.gsub('_ids', '').pluralize
      if hash[collection_name].blank?
        hash[collection_name] = { 'id' => nil }
      else
        hash[collection_name]['id'] = nil
      end
    end
  end

  def activerecord_model?(name)
    class_name = name.to_s.singularize.camelize
    begin
      class_name.constantize.ancestors.include?(ApplicationRecord)
    rescue NameError
      false
    end
  end

  def evaluate_model(parent, child)
    return unless parent.reflect_on_association(child)

    child_class_name = parent.reflect_on_association(child).class_name
    parent_class_name = parent.to_s.singularize.camelize

    return child_class_name.constantize if activerecord_model?(child_class_name)

    return unless activerecord_model?(parent_class_name)

    parent_class_name.constantize.reflections[child.to_s.underscore]&.klass
  end

  def parse_fields(irep_node)
    fields = irep_node&.scoped_children&.values&.first
    fields = fields['edges'].scoped_children.values.first['node']&.scoped_children&.values&.first if fields&.key?('edges')
    return if fields.blank?

    fields.each_with_object({}) do |(k, v), h|
      h[k] = v.scoped_children == {} ? v.definition.name : parse_fields(v)
    end
  end

  def model_name
    @model.class.to_s.split('::').first.underscore.pluralize
  end

end
