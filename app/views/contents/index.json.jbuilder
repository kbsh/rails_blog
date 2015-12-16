json.array!(@contents) do |content|
  json.extract! content, :id, :filename, :title
  json.url content_url(content, format: :json)
end
