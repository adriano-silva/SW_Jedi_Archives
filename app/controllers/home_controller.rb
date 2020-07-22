class HomeController < ApplicationController
  helper_method :get_all
  helper_method :get_all_types
  helper_method :to_json
  helper_method :get_types
  helper_method :execute_request_by_url
  helper_method :hash_to_json
  helper_method :get_data_hash
  require 'open-uri'
  require 'ostruct'

  BASE_URL = 'http://swapi.dev/api'
  TYPES = {1 => 'planets', 2  => 'people', 3 => 'starships', 4 => 'vehicles', 5 => 'species', 6 => 'films'}

  @data_hash = {}

  # Gets all ressource types of Swapi (Example: people, planets...)
  def get_types
    TYPES.values
  end

  # Gets Swapi API result hash
  def get_data_hash()
    @data_hash
  end

  # Gets all types and all elements from Swapi API. Makes requests for each types and each page.
  def get_all_types()
    results = Array.new
    TYPES.each_value do |value|
      results += get_all(value)
    end
    @data_hash = results
  end

  # Gets from Swapi API all data for {type}
  def get_all(type)
    get type
  end

  # Gets from Swapi API all data for {type} and {id}
  def get(type, id = '')
    response = to_json(execute_request("#{type}/#{id}"))
    results = response["results"]
    # While response has still values to query (paginated)
    while response["next"] != nil do
      response = to_json(execute_request_by_url(response["next"]))
      results += response["results"]
    end
    i = 0
    # Add type and id values for easier manipulation
    results.each do |element|
      element["type"] = type
      element["id"] = i
      i += 1
    end
    results
  end

  # Makes request to {BASE_URL} and {uri} and stores result in cache for next requests
  def execute_request(uri)
    Rails.cache.fetch([uri], :expires => 1.hour) do
      puts'Sending request to ' + "#{BASE_URL}/#{uri}"
      response = open("#{BASE_URL}/#{uri}", "User-Agent" => "swapi-ruby").read
    end
  end

  # Makes request to {url} and stores result in cache for next requests
  def execute_request_by_url(url)
    Rails.cache.fetch([url], :expires => 1.hour) do
      puts'Sending request to ' + url
      response = open(url).read
    end
  end

  # Converts data hash into json
  def to_json(data)
    JSON.parse(data)
  end


end
