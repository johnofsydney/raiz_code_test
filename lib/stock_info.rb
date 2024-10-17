require 'uri'
require 'net/http'

class StockInfo

  def self.price(stock_symbol)
    self.prices([stock_symbol])
  end

  def self.prices(stock_symbols)
    new(url: URI("https://latest-stock-price.p.rapidapi.com/equities-enhanced?Symbols=#{stock_symbols.join('%2C')}")).call
  end

  def self.price_all
    new(url: URI("https://latest-stock-price.p.rapidapi.com/equities")).call
  end

  def initialize(url: nil)
    @url = url
  end

  def call
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request["x-rapidapi-key"] = Rails.application.credentials.rapid_api[:key]
    request["x-rapidapi-host"] = 'latest-stock-price.p.rapidapi.com'

    response = http.request(request)

    JSON.parse(response.read_body).each do |stock|
      Stock.find_or_create_by!(code: stock['Symbol'], price: stock['Low'])
    end
  end

  private

  attr_reader :url
end