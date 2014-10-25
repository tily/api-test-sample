require 'ace-client'
require 'nokogiri'

describe 'CreateKeyPair' do
	def client
		@client = AceClient::Query2.new(
			endpoint: 'cp.cloud.nifty.com',
			path: '/api',
			use_ssl: true,
			access_key_id: ENV['ACCESS_KEY_ID'],
			secret_access_key: ENV['SECRET_ACCESS_KEY'],
                        before_signature: lambda {|params| params['AccessKeyId'] = params.delete('AWSAccessKeyId') }
		)
	end

	it 'Create key pair' do
		response = client.action('CreateKeyPair', 'KeyName' => 'apitest001', 'Password' => 'apitest001')
		expect(response.code).to eq(200)
	end

	it 'Describe key pairs' do
		response = client.action('DescribeKeyPairs', 'KeyName.1' => 'apitest001')
		doc = Nokogiri::XML response.response.body.gsub(/xmlns="(.+?)"/, '')
		expect(response.code).to eq(200)
		expect(doc.xpath('/DescribeKeyPairsResponse/keySet/item/keyName').text).to eq('apitest001')
	end

	it 'Delete key pair' do
		response = client.action('DeleteKeyPair', 'KeyName' => 'apitest001')
		expect(response.code).to eq(200)
	end
end
