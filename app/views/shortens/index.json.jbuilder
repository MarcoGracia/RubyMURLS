json.array!(@shortens) do |shorten|
  json.extract! shorten, :id, :url, :shortcode, :startdate, :lastseendate, :redirectcount
  json.url shorten_url(shorten, format: :json)
end
