require File.expand_path '../spec_helper.rb', __FILE__
require File.expand_path '../../models/task_tree', __FILE__

describe "PATCH /tasktrees/:id" do

  let(:ops_json) { '[{"op": "add", "path": "/baz", "value": "qux"}]' }
  let(:content_type) { "application/json-patch+json" }
  let(:task_tree) { TaskTree.new data: "{}" }
  let(:id) { "1" }
  let(:json_response) { JSON.parse(last_response.body) }
  subject(:request) {
    patch("/tasktree/#{id}", ops_json, "CONTENT_TYPE" => content_type)
  }

  before do
    allow(TaskTree).to receive(:find).with(id).and_return(task_tree)
  end


  describe "ADD operation" do

    context "when Content-Type is NOT 'application/json-patch+json'" do
      let(:content_type) { "application/foobar" }
      its(:status) { should eq 406 }
    end

    context "when Content-Type is 'application/json-patch+json'" do
      its(:status) { should eq 200 }
    end

    it "updates the task tree" do
      expect(task_tree).to receive(:update)
      request
    end

    it "returns the new task tree" do
      request
      expect(json_response).to eq("baz" => "qux")
    end
  end

end
