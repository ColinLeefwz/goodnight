RSpec.shared_examples 'confirms response schema' do
  example do
    subject
    assert_response_schema_confirm
  end
end
