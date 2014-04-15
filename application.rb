require 'sinatra'
require 'json'
require 'json/patch'
require 'sequel'


# TODO: Move this stuff
DB = Sequel.sqlite
DB.create_table :task_trees do
  primary_key :id
  varchar :name
  varchar :data
end


require './models/task_tree'

# TaskTree.new(name: "Test tasktree", data: {key: "value"}.to_json).save


get '/tasktrees' do
  @task_trees = TaskTree.all
  @task_trees.inspect
end

get '/tasktree/:id', provides: :json do |id|
  @task_trees = TaskTree.find id
  @task_trees.data
end

patch '/tasktree/:id' do |id|
  error 406 unless request.content_type == 'application/json-patch+json'
  error 404 unless @task_tree = TaskTree.find(id)
  @task_tree.update(data: JSON.patch(@task_tree.data, request.body.read)).data
end
