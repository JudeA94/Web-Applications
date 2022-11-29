require 'spec_helper'
require 'rack/test'
require_relative '../../app'

describe Application do
  include Rack::Test::Methods
  let(:app) { Application.new }

  context 'Get /names' do
    it 'returns 200 OK' do
      response = get('/names')
      expect(response.status).to be(200)
    end
    it 'should return "Julia, Mary, Karim"' do
      response = get('/names?names=Julia,Mary,Karim')
      expect(response.body).to eq('Julia,Mary,Karim')
    end
  end

  context 'Get /hello' do
    it 'returns the greeting message as an HTML page ontaining a h1 title' do
      response = get('/hello')
      expect(response.body).to include('<h1>Hello!</h1>')
    end
  end

  context 'Post /sort-names' do
    it 'returns 200 OK' do
      response = post('/sort-names?names=Julia,Mary,Karim,Abdul')
      expect(response.status).to be(200)
    end

    it 'returns a list of names sorted in alphabetical order' do
      response = post('/sort-names?names=Julia,Mary,Karim,Abdul')
      expect(response.body).to eq('Abdul, Julia, Karim, Mary')
    end

    it 'returns a different list of names sorted in alphabetical order' do
      response = post('/sort-names?names=Jude,Maria,Kate,Alfie')
      expect(response.body).to eq('Alfie, Jude, Kate, Maria')
    end
  end
end
