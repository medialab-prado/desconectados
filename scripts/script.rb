require 'bundler'
Bundler.require
require 'csv'

CATEGORIES = ['Educació. Formació', 'Salut', 'Mobilitat. Transports']

doc = File.open("equipaments.rdf") { |f| Nokogiri::XML(f) }

CSV.open("datos_cat.csv", "wb") do |csv|
  csv << [ 'nombre','direccion','municipio','codigo postal', 'comarca', 'lat', 'lon', 'categorias' ]

  doc.xpath('//v:VCard').each do |item|
    categories = item.xpath('v:category').map(&:text)
    next if categories.none?{ |c| CATEGORIES.include?(c) }

    row = []
    row << item.xpath('v:fn').text
    row << item.xpath('v:adr/rdf:Description/v:street-address').text.strip
    row << item.xpath('v:adr/rdf:Description/v:locality').text.strip
    row << item.xpath('v:adr/rdf:Description/v:postal-code').text.strip
    row << item.xpath('v:adr/rdf:Description/v:region').text.strip
    row << item.xpath('v:geo/rdf:Description/v:latitude').text.strip
    row << item.xpath('v:geo/rdf:Description/v:longitude').text.strip
    row << categories.join(',')
    csv << row
  end
end
