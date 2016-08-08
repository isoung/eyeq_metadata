require 'rest-client'
require 'nokogiri'

class EyeQ
  attr_reader :eyeq_url, :eyeq_userid, :eyeq_clientid

  def initialize(clientid, clientid_tag)
    @eyeq_url = "https://c#{clientid}.ipg.web.cddbp.net/webapi/xml/1.0/"
    @eyeq_clientid = "#{clientid}-#{clientid_tag}"

    register_query = "<QUERIES><QUERY CMD='REGISTER'><CLIENT>#{@eyeq_clientid}</CLIENT></QUERY></QUERIES>"
    response = RestClient.post(@eyeq_url, register_query, content_type: 'text/xml')
    response_xml = Nokogiri::XML(response.body)

    raise 'Invalid clientid or clientid_tag. Query returned an ERROR.' if response_xml.css('RESPONSE').attr('STATUS').text == 'ERROR'
    @eyeq_userid = response_xml.css('USER').text
  end

  def request(options)
    query = construct_query(options)
    response = RestClient.post(@eyeq_url, query, content_type: 'text/xml')
    Nokogiri::XML(response.body)
  end

  private

  def construct_query(options)
    query = '<QUERIES>'
    query += options[:lang].nil? ? lang : lang(options[:lang])
    query += options[:country].nil? ? country : country(options[:country])
    query + "#{auth}#{get_query_type(options)}</QUERIES>"
  end

  def get_query_type(options)
    query_type = nil

    case options[:query_type].downcase
    when 'tvchannel_fetch'
      throw new Error(':gnid option required') if options[:gnid].nil?
      query_type = tvchannel_fetch(options[:gnid])
    when 'tvchannel_lookup_by_provider'
      throw new Error(':gnid option required') if options[:gnid].nil?
      query_type = tvchannel_lookup_by_provider(options[:gnid])
    when 'tvprovider_na'
      throw new Error(':zipcode option required') if options[:zipcode].nil?
      query_type = tvprovider_na(options[:zipcode])
    when 'tvprovider_or'
      throw new Error(':tvregion option required') if options[:tvregion].nil?
      query_type = tvprovider_or(options[:tvregion])
    when 'tvprogram_fetch'
      throw new Error(':gnid option required') if options[:gnid].nil?
      query_type = tvprogram_fetch(options[:gnid])
    end

    query_type
  end

  def lang(lang = 'eng')
    "<LANG>#{lang}</LANG>"
  end

  def country(country = 'usa')
    "<COUNTRY>#{country}</COUNTRY>"
  end

  def auth
    "<AUTH><CLIENT>#{@eyeq_clientid}</CLIENT><USER>#{@eyeq_userid}</USER></AUTH>"
  end

  def tvchannel_fetch(gnid)
    "<QUERY CMD='TVCHANNEL_FETCH'><GN_ID>#{gnid}</GN_ID></QUERY>"
  end

  def tvchannel_lookup_by_provider(gnid)
    "<QUERY CMD='TVCHANNEL_LOOKUP'><MODE>TVPROVIDER</MODE><GN_ID>#{gnid}</GN_ID></QUERY>"
  end

  def tvprovider_na(zipcode)
    "<QUERY CMD='TVPROVIDER_LOOKUP'><POSTALCODE>#{zipcode}</POSTALCODE></QUERY>"
  end

  def tvprovider_or(tvregion)
    "<QUERY CMD='TVPROVIDER_LOOKUP'><TVREGION>#{tvregion}</TVREGION></QUERY>"
  end

  def tvprogram_fetch(gnid)
    "<QUERY CMD='TVPROGRAM_FETCH'><GN_ID>#{gnid}</GN_ID></QUERY>"
  end
end
