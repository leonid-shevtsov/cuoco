ruby_block "save node data for Cuoco" do
  block do
    File.open('/tmp/test.json', 'w') {|f| f.write node.to_json}
  end
  action :create
end