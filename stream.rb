require_relative './lib/eyeq_metadata'

eyeq = EyeQ.new('5375232', 'DA83FFC82C8A5056BBCDDD7414E40228')
response = eyeq.request(query_type: 'tvgrid_lookup', tvchannel_gnid: '251533812-849E7344B3F4949318DEB768899B4BB9', date_start: '2016-08-17T02:00', date_end: '2016-08-17T03:00')

puts response
