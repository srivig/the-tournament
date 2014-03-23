# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Category.create([
  {tag_name:'サッカー',         category_name: 'スポーツ'},
  {tag_name:'バスケットボール', category_name: 'スポーツ'},
  {tag_name:'野球',             category_name: 'スポーツ'},
  {tag_name:'テニス',           category_name: 'スポーツ'},
  {tag_name:'バドミントン',     category_name: 'スポーツ'},
  {tag_name:'柔道',             category_name: 'スポーツ'},
  {tag_name:'卓球',             category_name: 'スポーツ'},
  {tag_name:'MAGIC THE GATHERING', category_name: 'ゲーム'},
  {tag_name:'将棋',                category_name: 'ゲーム'},
  {tag_name:'人狼',                category_name: 'ゲーム'}
])

