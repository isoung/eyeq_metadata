require 'nokogiri'
require 'httpi'

class EyeQ
  attr_reader :eyeq_url, :eyeq_userid, :eyeq_clientid

  def initialize(clientid, clientid_tag)
    @eyeq_url = "https://c#{clientid}.ipg.web.cddbp.net/webapi/xml/1.0/"
    @eyeq_clientid = "#{clientid}-#{clientid_tag}"
    HTTPI.log = false

    register_query = "<QUERIES><QUERY CMD='REGISTER'><CLIENT>#{@eyeq_clientid}</CLIENT></QUERY></QUERIES>"
    response = HTTPI.post(construct_request(register_query))

    response_xml = Nokogiri::XML(response.body)

    raise 'Invalid clientid or clientid_tag. Query returned an ERROR.' if response_xml.css('RESPONSE').attr('STATUS').text == 'ERROR'
    @eyeq_userid = response_xml.css('USER').text
  end

  def request(options)
    query = construct_query(options)
    response = HTTPI.post(construct_request(query))
    Nokogiri::XML(response.body)
  end

  private

  def construct_request(query)
    request = HTTPI::Request.new(url: @eyeq_url, body: query)
    request.headers['Content-Type'] = 'text/xml'
    request
  end

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
    when 'tvgrid_search'
      throw new Error(':program_title option required') if options[:program_title].nil?
      throw new Error(':tvchannel_gnid option required') if options[:tvchannel_gnid].nil?
      query_type = tvgrid_search(options)
    when 'tvgrid_lookup'
      throw new Error(':tvchannel_gnid option required') if options[:tvchannel_gnid].nil?
      query_type = tvgrid_lookup(options)
    end

    puts query_type
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

  def tvgrid_search(options)
    program_title = options[:program_title]
    tvchannel_gnid = options[:tvchannel_gnid]

    query = "<QUERY CMD='TVGRID_SEARCH'><TEXT TYPE='TVPROGRAM_TITLE'>#{program_title}</TEXT><TVCHANNEL>"
    return query << "<GN_ID>#{tvchannel_gnid}</GN_ID></TVCHANNEL>#{insert_date_time(options)}</QUERY>" unless tvchannel_gnid.is_a? Array

    tvchannel_gnid.each do |gnid|
      query << "<GN_ID>#{gnid}</GN_ID>"
    end
    query << "</TVCHANNEL>#{insert_date_time(options)}</QUERY>"
  end

  def tvgrid_lookup(options)
    tvchannel_gnid = options[:tvchannel_gnid]

    query = "<QUERY CMD='TVGRID_LOOKUP'><TVCHANNEL>"
    return query << "<GN_ID>#{tvchannel_gnid}</GN_ID></TVCHANNEL>#{insert_date_time(options)}</QUERY>" unless tvchannel_gnid.is_a? Array

    tvchannel_gnid.each do |gnid|
      query << "<GN_ID>#{gnid}</GN_ID>"
    end
    query << "</TVCHANNEL>#{insert_date_time(options)}</QUERY>"
  end

  def insert_date_time(options)
    date_start = options[:date_start] unless options[:date_start].nil?
    date_end = options[:date_end] unless options[:date_end].nil?

    date = "<DATE TYPE='START'>#{date_start}</DATE>" unless options[:date_start].nil?
    date << "<DATE TYPE='END'>#{date_end}</DATE>" unless options[:date_end].nil?
  end
end
