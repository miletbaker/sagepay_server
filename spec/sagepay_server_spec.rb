require File.dirname(__FILE__) + '/spec_helper'

describe SagepayServer do

  context "URL Building" do
    
    it "should build a registration URL for simulator payment transaction" do
      SagepayServer.mode = :simulator
      SagepayServer.should_receive(:post).with("https://test.sagepay.com/Simulator/VSPServerGateway.asp?Service=VendorRegisterTx", anything).and_return({:status => "OK"})
      s = SagepayServer.new("hello")
      s.payment({:tx => "12"})
    end
    
    it "should build a registration URL for simulator authenticate transaction" do
      SagepayServer.mode = :simulator
      SagepayServer.should_receive(:post).with("https://test.sagepay.com/Simulator/VSPServerGateway.asp?Service=VendorRegisterTx", anything).and_return({:status => "OK"})
      s = SagepayServer.new("hello")
      s.authenticate({:tx => "12"})
    end
    
    it "should build a registration URL for simulator deferred transaction" do
      SagepayServer.mode = :simulator
      SagepayServer.should_receive(:post).with("https://test.sagepay.com/Simulator/VSPServerGateway.asp?Service=VendorRegisterTx", anything).and_return({:status => "OK"})
      s = SagepayServer.new("hello")
      s.deferred({:tx => "12"})
    end
    
    it "should build a registration URL for test payment transaction" do
      SagepayServer.mode = :test
      SagepayServer.should_receive(:post).with("https://test.sagepay.com/gateway/service/vspdirect-register.vsp", anything).and_return({:status => "OK"})
      s = SagepayServer.new("hello")
      s.payment({:tx => "12"})
    end
    
    it "should build a registration URL for test authenticate transaction" do
      SagepayServer.mode = :test
      SagepayServer.should_receive(:post).with("https://test.sagepay.com/gateway/service/vspdirect-register.vsp", anything).and_return({:status => "OK"})
      s = SagepayServer.new("hello")
      s.authenticate({:tx => "12"})
    end
    
    it "should build a registration URL for test deferred transaction" do
      SagepayServer.mode = :test
      SagepayServer.should_receive(:post).with("https://test.sagepay.com/gateway/service/vspdirect-register.vsp", anything).and_return({:status => "OK"})
      s = SagepayServer.new("hello")
      s.deferred({:tx => "12"})
    end
    
    it "should build a registration URL for live payment transaction" do
      SagepayServer.mode = :live
      SagepayServer.should_receive(:post).with("https://live.sagepay.com/gateway/service/vspdirect-register.vsp", anything).and_return({:status => "OK"})
      s = SagepayServer.new("hello")
      s.payment({:tx => "12"})
    end
    
    it "should build a registration URL for live authenticate transaction" do
      SagepayServer.mode = :live
      SagepayServer.should_receive(:post).with("https://live.sagepay.com/gateway/service/vspdirect-register.vsp", anything).and_return({:status => "OK"})
      s = SagepayServer.new("hello")
      s.authenticate({:tx => "12"})
    end
    
    it "should build a registration URL live for deferred transaction" do
      SagepayServer.mode = :live
      SagepayServer.should_receive(:post).with("https://live.sagepay.com/gateway/service/vspdirect-register.vsp", anything).and_return({:status => "OK"})
      s = SagepayServer.new("hello")
      s.deferred({:tx => "12"})
    end
    
    it "should build a method url for any other simulator transaction, i.e. authorise" do
      SagepayServer.mode = :simulator
      SagepayServer.should_receive(:post).with("https://test.sagepay.com/Simulator/VSPServerGateway.asp?Service=VendorAuthoriseTx", anything).and_return({:status => "OK"})
      s = SagepayServer.new("hello")
      s.authorise({:tx => "12"})
    end
    
    it "should build a method url for any other test transaction, i.e. authorise" do
      SagepayServer.mode = :test
      SagepayServer.should_receive(:post).with("https://test.sagepay.com/gateway/service/authorise.vsp", anything).and_return({:status => "OK"})
      s = SagepayServer.new("hello")
      s.authorise({:tx => "12"})
    end
    
    it "should build a method url for any other live transaction, i.e. authorise" do
      SagepayServer.mode = :live
      SagepayServer.should_receive(:post).with("https://live.sagepay.com/gateway/service/authorise.vsp", anything).and_return({:status => "OK"})
      s = SagepayServer.new("hello")
      s.authorise({:tx => "12"})
    end
    
  end

  context "Provide defaults on service calls" do
    
    it "should inject vendor" do
      SagepayServer.should_receive(:post) do |url, options|  
        options[:body]["Vendor"].should == "hello"  
      end
      s = SagepayServer.new("hello")
      s.release({:tx => "12"})
    end
    
    it "should inject transaction type" do
      SagepayServer.should_receive(:post) do |url, options|  
        options[:body]["TxType"].should == "ABORT"  
      end
      s = SagepayServer.new("hello")
      s.abort({:tx => "12"})
    end
    
    it "should inject profile" do
      SagepayServer.profile = :normal
      SagepayServer.should_receive(:post) do |url, options|  
        options[:body]["Profile"].should == "NORMAL"  
      end
      s = SagepayServer.new("hello")
      s.refund({:tx => "12"})
    end
    
    it "should inject protocol version" do
      SagepayServer.should_receive(:post) do |url, options|  
        options[:body]["VPSProtocol"].should == SagepayServer::VERSION  
      end
      s = SagepayServer.new("hello")
      s.repeat({:tx => "12"})
    end
    
    it "should inject through passed hash" do
      SagepayServer.should_receive(:post) do |url, options|  
        options[:body][:VendorTxCode].should == "12"
        options[:body][:Amount].should == 23.99
      end
      s = SagepayServer.new("hello")
      s.void({:VendorTxCode => "12", :Amount => 23.99})
    end
    
  end

  context "Decoding hash" do
    
    it "should identify hash as correct" do
      SagepayServer.should_receive(:post).and_return({:vps_tx_id => "12345", :vendor_tx_code => "12", :status => "OK", :tx_auth_no => 987654321, :avscv2 => "ALL MATCH", :address_result => "MATCHED", :post_code_result => "MATCHED", :cv2_result => "MATCHED", :gift_aid => 0, :"3_d_secure_status" => "OK", :cavv => "h23h324j23", :address_status => "CONFIRMED", :payer_status => "VERIFIED", :card_type => "VISA", :last4_digits => "1234", :vps_signature => "D2F733F60BD97C3E1162C35C467BBDA2"})
      s = SagepayServer.new("hello")
      response = s.manual({})
      s.check_response(response, "secret").should be_true
    end
    
    it "should identify hash correctly with missing params" do
      SagepayServer.should_receive(:post).and_return({:vps_tx_id => "12345", :vendor_tx_code => "12", :status => "OK", :tx_auth_no => 987654321, :avscv2 => "ALL MATCH", :address_result => "MATCHED", :post_code_result => "MATCHED", :cv2_result => "MATCHED", :cavv => "h23h324j23", :card_type => "VISA", :last4_digits => "1234", :vps_signature => "70E7EDAB35B06B0984E11419C8CFC266"})
      s = SagepayServer.new("hello")
      response = s.directrefund({})
      s.check_response(response, "secret").should be_true
    end
    
    it "should identify hash as incorrect" do
      SagepayServer.should_receive(:post).and_return({:vps_tx_id => "12344", :vendor_tx_code => "12", :status => "OK", :tx_auth_no => 987654321, :avscv2 => "ALL MATCH", :address_result => "MATCHED", :post_code_result => "MATCHED", :cv2_result => "MATCHED", :gift_aid => 0, :"3_d_secure_status" => "OK", :cavv => "h23h324j23", :address_status => "CONFIRMED", :payer_status => "VERIFIED", :card_type => "VISA", :last4_digits => "1234", :vps_signature => "D2F733F60BD97C3E1162C35C467BBDA2"})
      s = SagepayServer.new("hello")
      response = s.manual({})
      s.check_response(response, "secret").should be_false
    end
    
  end

end

describe SagepayServer::Parser::Sagepay do

  it "should correctly parse newline keyvalue pairs into a hash" do
    response = SagepayServer::Parser::Sagepay.call("key1=value 1\nkey2=value2", :plain)
    response[:key1].should == "value 1"
    response[:key2].should == "value2"
  end

  it "should underscore keys" do
    response = SagepayServer::Parser::Sagepay.call("StatusDetail=Correctly parsed text", :plain)
    response[:status_detail].should == "Correctly parsed text"
  end

  it "should (it) decode 3D as 3_d" do
    response = SagepayServer::Parser::Sagepay.call("3DSecureStatus=OK", :plain)
    response[:"3_d_secure_status"].should == "OK"
  end

end