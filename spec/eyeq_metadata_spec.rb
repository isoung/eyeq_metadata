require 'spec_helper'

describe EyeQ do
  test_clientid = '1234567'
  test_clientid_tag = '12341234123412341234123412341234'

  def create_fake_request(query_type)
    query_body = @test_data[query_type]['query'][0]
    response = @test_data[query_type]['response'][0]
    status = @test_data[query_type]['status'][0]

    stub_request(:post, 'https://c1234567.ipg.web.cddbp.net/webapi/xml/1.0/')
      .with(
        body: query_body,
        headers: {
          'Accept' => '*/*',
          'Content-Type' => 'text/xml',
          'User-Agent' => 'HTTPClient/1.0 (2.7.1, ruby 2.0.0 (2015-12-16))'
        }
      )
      .to_return(
        status: status,
        body: response,
        headers: {}
      )
  end

  before(:all) do
    @test_data = YAML.load_stream(File.read('./spec/test_data.yml'))[0]
    create_fake_request('register_query')
    @eyeq = EyeQ.new(test_clientid, test_clientid_tag)
  end

  it 'should return an eyeq_userid' do
    expect(@eyeq.eyeq_userid).to match('USER_IS_INITIALIZED')
  end

  it 'should return an eyeq_url' do
    expect(@eyeq.eyeq_url).to match('https://c1234567.ipg.web.cddbp.net/webapi/xml/1.0/')
  end

  it 'should return an eyeq_clientid' do
    expect(@eyeq.eyeq_clientid).to match('1234567-12341234123412341234123412341234')
  end

  it 'should return a stubbed response after a request' do
    create_fake_request('tvchannel_fetch_query')
    response = @eyeq.request(query_type: 'tvchannel_fetch', gnid: '123-456-789')
    expect(response.css('RESPONSE').text).to match('FAKE_TV_CHANNEL')
  end

  it 'should return a stubbed response after a avwork_fetch' do
    create_fake_request('avwork_fetch_query')
    response = @eyeq.request(query_type: 'avwork_fetch', gnid: '123-456-789')
    expect(response.css('RESPONSE').text).to match('FAKE_AV_WORK')
  end
end
