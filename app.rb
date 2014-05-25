require 'sinatra'
require 'data_mapper'

DataMapper.setup(:default, ENV["DATABASE_URL"] || "sqlite3://#{Dir.pwd}/contractor.db")

class Snippet

  attr_accessor :kind_array

  def self.number_of_kind(kind) ### This is a method to return the number of snippets in a category
    x = 0
    self.all.each do |snip|
      if snip.kind.include?(kind)
        x += 1
      end
    end
    x
  end

  def self.kind_list(kind) ### This is a method to list all of the snippets of a certain category
    @kind_array = []
    self.all.each do |snip|
      if snip.kind == kind
        @kind_array << snip
      end
    end
    @kind_array
  end

  include DataMapper::Resource



  property :id,     Serial

  property :kind,   String
  property :title,  Text
  property :work,   Text

end

DataMapper.finalize

Snippet.auto_upgrade!

get '/' do
  @snippets = Snippet.all 
  @ruby = Snippet.number_of_kind 'Ruby'
  @js = Snippet.number_of_kind 'JavaScript'
  @cs = Snippet.number_of_kind 'CoffeeScript'
  @html = Snippet.number_of_kind 'HTML'
  @css = Snippet.number_of_kind 'CSS'

  erb :index, layout: :default_layout
end

get '/snippets/:id' do |id|
  if id == 'ruby'
    @snippets = Snippet.kind_list 'Ruby'
    erb :ruby, layout: :default_layout
  elsif id == 'js'
    @snippets = Snippet.kind_list 'JavaScript'
    erb :javascript, layout: :default_layout
  elsif id == 'cs'
    @snippets = Snippet.kind_list 'CoffeeScript'
    erb :coffeescript, layout: :default_layout
  elsif id == 'html'
    @snippets = Snippet.kind_list 'HTML'
    erb :html, layout: :default_layout
  elsif id == 'css'
    @snippets = Snippet.kind_list 'CSS'
    erb :css, layout: :default_layout
  end
end


get '/add' do
  erb :add_snippet, layout: :default_layout
end

post '/add' do
  Snippet.create(params)

  redirect to('/')

end
