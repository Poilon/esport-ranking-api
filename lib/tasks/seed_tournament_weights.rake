namespace :db do
  task seed_tournament_weights: :environment do
    rankings = [
      { rank: 1,   country: 'USA',             name: 'Hungrybox'         },
      { rank: 2,   country: 'Sweden',          name: 'Leffen'            },
      { rank: 3,   country: 'USA',             name: 'Mang0'             },
      { rank: 4,   country: 'USA',             name: 'Axe'               },
      { rank: 5,   country: 'USA',             name: 'Wizzrobe'          },
      { rank: 6,   country: 'USA',             name: 'Zain'              },
      { rank: 7,   country: 'Japan',           name: 'aMSa'              },
      { rank: 8,   country: 'USA',             name: 'Plup'              },
      { rank: 9,   country: 'USA',             name: 'iBDW'              },
      { rank: 10,  country: 'USA',             name: 'Mew2King'          },
      { rank: 11,  country: 'USA',             name: 'S2J'               },
      { rank: 12,  country: 'USA',             name: 'Fiction'           },
      { rank: 13,  country: 'USA',             name: 'SFAT'              },
      { rank: 14,  country: 'Canada',          name: 'moky'              },
      { rank: 15,  country: 'Canada',          name: 'n0ne'              },
      { rank: 16,  country: 'Spain',           name: 'Trif'              },
      { rank: 17,  country: 'USA',             name: 'Captain Faceroll'  },
      { rank: 18,  country: 'USA',             name: 'Swedish Delight'   },
      { rank: 19,  country: 'USA',             name: 'Hax$'              },
      { rank: 20,  country: 'USA',             name: 'Lucky'             },
      { rank: 21,  country: 'USA',             name: 'Ginger'            },
      { rank: 22,  country: 'USA',             name: 'Spark'             },
      { rank: 23,  country: 'USA',             name: 'ChuDat'            },
      { rank: 24,  country: 'USA',             name: 'PewPewU'           },
      { rank: 25,  country: 'USA',             name: 'lloD'              },
      { rank: 26,  country: 'USA',             name: 'ARMY'              },
      { rank: 27,  country: 'USA',             name: 'AbsentPage'        },
      { rank: 28,  country: 'USA',             name: 'Bananas'           },
      { rank: 29,  country: 'USA',             name: 'KJH'               },
      { rank: 30,  country: 'USA',             name: 'Shroomed'          },
      { rank: 31,  country: 'USA',             name: 'Westballz'         },
      { rank: 32,  country: 'USA',             name: 'Medz'              },
      { rank: 33,  country: 'USA',             name: 'MikeHaze'          },
      { rank: 34,  country: 'UK',              name: 'Professor Pro'     },
      { rank: 35,  country: 'USA',             name: '2saint'            },
      { rank: 36,  country: 'USA',             name: 'Gahtzu'            },
      { rank: 37,  country: 'USA',             name: 'Albert'            },
      { rank: 38,  country: 'New Zealand',     name: 'Spud'              },
      { rank: 39,  country: 'USA',             name: 'FatGoku'           },
      { rank: 40,  country: 'USA',             name: 'Rishi'             },
      { rank: 41,  country: 'Mexico',          name: 'Bimbo'             },
      { rank: 42,  country: 'UK',              name: 'Setchi'            },
      { rank: 43,  country: 'USA',             name: 'Magi'              },
      { rank: 44,  country: 'USA',             name: 'Morsecode762'      },
      { rank: 45,  country: 'USA',             name: 'Jakenshaken'       },
      { rank: 46,  country: 'USA',             name: 'HugS'              },
      { rank: 47,  country: 'USA',             name: 'Stango'            },
      { rank: 48,  country: 'USA',             name: 'Zamu'              },
      { rank: 49,  country: 'USA',             name: 'Drephen'           },
      { rank: 50,  country: 'USA',             name: 'Michael'           },
      { rank: 51,  country: 'Germany',         name: 'Ice'               },
      { rank: 52,  country: 'USA',             name: 'billybopeep'       },
      { rank: 53,  country: 'USA',             name: 'La Luna'           },
      { rank: 54,  country: 'USA',             name: 'Colbol'            },
      { rank: 55,  country: 'Spain',           name: 'Overtriforce'      },
      { rank: 56,  country: 'USA',             name: 'Slox'              },
      { rank: 57,  country: 'USA',             name: 'Kalamazhu'         },
      { rank: 58,  country: 'USA',             name: 'Nickemwit'         },
      { rank: 59,  country: 'USA',             name: 'Jerry'             },
      { rank: 60,  country: 'USA',             name: 'Aura'              },
      { rank: 61,  country: 'USA',             name: 'Nut'               },
      { rank: 62,  country: 'USA',             name: 'Kalvar'            },
      { rank: 63,  country: 'USA',             name: 'Polish'            },
      { rank: 64,  country: 'USA',             name: 'Kevin Maples'      },
      { rank: 65,  country: 'USA',             name: 'Bladewise'         },
      { rank: 66,  country: 'USA',             name: 'Tai'               },
      { rank: 67,  country: 'USA',             name: 'Squid'             },
      { rank: 68,  country: 'USA',             name: 'Forrest'           },
      { rank: 69,  country: 'USA',             name: 'Joyboy'            },
      { rank: 70,  country: 'USA',             name: 'KoDoRiN'           },
      { rank: 71,  country: 'Canada',          name: 'Ryan'              },
      { rank: 72,  country: 'USA',             name: 'Free Palestine'    },
      { rank: 73,  country: 'USA',             name: 'Ryobeat'           },
      { rank: 74,  country: 'USA',             name: 'Ka-Master'         },
      { rank: 75,  country: 'USA',             name: 'Kürv'              },
      { rank: 76,  country: 'UK',              name: 'Frenzy'            },
      { rank: 77,  country: 'USA',             name: 'MoG'               },
      { rank: 78,  country: 'USA',             name: 'Boyd'              },
      { rank: 79,  country: 'USA',             name: 'Cool Lime'         },
      { rank: 80,  country: 'USA',             name: 'bobby big ballz'   },
      { rank: 81,  country: 'USA',             name: 'Nintendude'        },
      { rank: 82,  country: 'USA',             name: 'Franz'             },
      { rank: 83,  country: 'Germany',         name: 'Nicki'             },
      { rank: 84,  country: 'USA',             name: 'lint'              },
      { rank: 85,  country: 'USA',             name: 'King Momo'         },
      { rank: 86,  country: 'USA',             name: 'TheRealThing'      },
      { rank: 87,  country: 'USA',             name: 'Umarth'            },
      { rank: 88,  country: 'USA',             name: 'Zeo'               },
      { rank: 89,  country: 'Norway',          name: 'Pricent'           },
      { rank: 90,  country: 'USA',             name: 'Prince Abu'        },
      { rank: 91,  country: 'Netherlands',     name: 'Amsah'             },
      { rank: 92,  country: 'USA',             name: 'Rocky'             },
      { rank: 93,  country: 'USA',             name: 'Sharkz'            },
      { rank: 94,  country: 'USA',             name: 'HTwa'              },
      { rank: 95,  country: 'Canada',          name: 'Kage'              },
      { rank: 96,  country: 'USA',             name: 'Schythed'          },
      { rank: 97,  country: 'USA',             name: 'Panda'             },
      { rank: 98,  country: 'Canada',          name: 'Soonsay'           },
      { rank: 99,  country: 'USA',             name: 'TheSWOOPER'        },
      { rank: 100, country: 'USA',             name: 'Snowy'             }
    ]
    top_15_ids = []
    top_100_ids = []

    rankings.each do |r|
      player = Player.find_by(name: r[:name])
      next puts "Player #{r[:name]} not found" unless player

      player.update(current_mpgr_ranking: r[:rank])
      player.update(elo: (3000 - (r[:rank] * 10)))
      top_15_ids << player.id if r[:rank] <= 15
      top_100_ids << player.id
    end

    Tournament.joins(results: :player).where(results: { players: { current_mpgr_ranking: (1..100) } }).each do |tournament|
      weight = 1000
      tournament.results.each do |r|
        weight += 2000 if top_15_ids.include?(r.player_id)
        weight += 500 if top_100_ids.include?(r.player_id)
      end
      tournament.update(weight: weight)
    end

  end
end
