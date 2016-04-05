json.data do
  json.id address.id.to_s
  json.type "addresses"
  json.attributes address.attributes.except(:id, :type)
end