require 'httparty'
# SagepayServer
class SagepayServer
  
  include HTTParty
  format :xml

	cattr_accessor :mode
	self.mode = :live # modes = :live, :test, :simulator

  cattr_accessor :profile
  self.profile = :low # profiles = :low, :normal

	TEST_URL = 'https://test.sagepay.com/gateway/service'
	LIVE_URL = 'https://live.sagepay.com/gateway/service'
	SIMULATOR_URL = 'https://test.sagepay.com/Simulator'

  VERSION = "2.23"

  REGISTRATION_METHODS = [:payment, :authenticate, :deferred]
  SUPPORTED_METHODS = [:release, :abort, :refund, :repeat, :void, :manual, :directrefund, :authorise, :cancel].concat(REGISTRATION_METHODS)

  def initialize(vendor_name)
    @vendor_name = vendor_name
  end

  def method_missing(method_name, args={})
      super unless SUPPORTED_METHODS.include?(method_name)
      url = self.mode == :simulator ? build_simulator_url(method_name) : build_url(method_name)
      self.class.post(url, :body => args.merge('Vendor' => @vendor_name, 'VPSProtocol' => VERSION, 'TxType' => method_name.to_s.upcase, 'Profile' => self.profile.to_s.upcase))
  end
  
  def build_url(method_name)
    endpoint = REGISTRATION_METHODS.include?(method_name) ? "vspdirect-register" : method_name.to_s.downcase
    "#{self.mode == :test ? TEST_URL : LIVE_URL}/#{endpoint}.vsp"
  end
  
  def build_simulator_url(method_name)
    endpoint = REGISTRATION_METHODS.include?(method_name) ? "VSPServerGateway.asp?Service=VendorRegisterTx" : "VSPServerGateway.asp?Service=Vendor#{method_name.to_s.capitalize}Tx"
    "#{SIMULATOR_URL}/#{endpoint}"
  end
  
  class Parser::Sagepay < HTTParty::Parser
    # Sagepay returns data in the following format
    # Key1=value1
    # Key2=value2
    def parse
      result = {}
      body.to_a.each { |pair| result[$1.underscore.to_sym] = $2 if pair.strip =~ /\A([^=]+)=(.+)\Z/im }
      result
    end
  end
  
  parser Parser::Sagepay
  
  def self.check_response(vendor_name, security_key, response)
  		hash_source = response[:VPSTxId].to_s + response[:VendorTxCode].to_s + response[:Status].to_s + response[:TxAuthNo].to_s + vendor_name + response[:AVSCV2].to_s + security_key.to_s + response[:AddressResult].to_s + response[:PostCodeResult].to_s + response[:CV2Result].to_s + response[:GiftAid].to_s + response[:"3DSecureStatus"].to_s + response[:CAVV].to_s + response[:AddressStatus].to_s + response[:PayerStatus].to_s + response[:CardType].to_s + response[:Last4Digits].to_s
  		puts Digest::MD5.hexdigest(hash_source).upcase
  		return response[:VPSSignature] == Digest::MD5.hexdigest(hash_source).upcase
  end
  
end