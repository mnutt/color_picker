require 'rubygems'
require 'sinatra'
require 'mongo'
require 'erb'
require 'json/pure'

get '/' do
  @db = Mongo::Connection.new.db('gilt-look-colors')
  @coll = @db.collection("looks")
  @looks = @coll.find.limit(500)
  erb :index
end

get '/scroll' do
  erb :scroll
end

get '/search.?:format?/:red/:green/:blue' do
  limit = params[:format] ? 12 : 300
  @red, @green, @blue = %w(red green blue).map{|c| params[c.to_sym].to_i }
  @color = "rgb(#{@red}, #{@green}, #{@blue})"
  @db = Mongo::Connection.new.db('gilt-look-colors')
  @coll = @db.collection("colors")
  @colors = @coll.find("red" => { "$gt" => @red.to_i - 15, "$lt" => @red.to_i + 15 },
                       "green" => { "$gt" => @green.to_i - 15, "$lt" => @green.to_i + 15},
                       "blue" => { "$gt" => @blue.to_i - 15, "$lt" => @blue.to_i + 15},
                       "amount" => { "$gt" => 100 }).sort(["amount", 'descending']).limit(limit)

  if params[:format]
    color_hash = @colors.to_a.map { |c|
      {
        :color => {
          :red => c["red"],
          :green => c["green"],
          :blue => c["blue"]
        },
        :image_path => c["look"]["image_path"].sub(/\/Users\/michael\/code\/gilt\/share\/public\/uploads/, "http://localhost:3000/images/share/uploads")
      }
    }
    JSON.generate(color_hash)
  else
    erb :search
  end
end
