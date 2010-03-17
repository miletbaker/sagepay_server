Sagepay Server
==============

Lightweight wrapper for Sagepay's Server Implementation API for Ruby on Rails over HTTP using HTTParty.

About
-----

As the server implementation does not fit the ActiveMerchant model (due to redirects to the SagePay to complete payment). This is a very simple class that leverages the power of HTTParty to implement the full SagePay Server API in 63 lines of code.

Installation
------------

Make sure you have the HTTParty gem installed

	sudo gem install htparty
	
Then install as a plugin

    script/plugin install git://github.com/miletbaker/sagepay_server.git
    
Usage
-----

You should familiarise yourself with the SagePay Server Implementation API documentation found here: [http://www.sagepay.com/developers.asp]. You can call any transaction action on an instance of SagepayServer, _including payment, authenticate, deferred, release, abort, refund, repeat, void, manual, directrefund, authorise and cancel_

The Vendor, VPSVersion, TxType and Profile parameters are added automatically, just pass the others as arguments to the method. i.e. 

    VENDOR = '...'
    
    ss = SagepayServer.new(VENDOR)
    
    response = ss.payment(
      'VendorTxCode' => '...',
      'Amount'  => 1029.99,
      'Currency'   => 'GBP',
	  'Description' => 'Canon EOS 7D',
	  'NotificationURL' => 'http://www.myserver.com/notify',
	  ...
    )
    
Responds with a hash
	
	{ :status => "OK", :security_key => "...", :next_url => "..." }
	
You can then use the next_url parameter to embed the payment page within an iframe or redirect the user to Sagepay to complete the payment. By default the plugin injects the Profile=LOW property to display the cut down payment form for iframes, if you would like to set the profile page as normal, set before your call or in your environment file / initializer:

	SagepayServer.profile = :normal


You can set which Sagepay environment the plugin uses by setting the following attribute:

	SagepayServer.mode = :test # Use the test environment
	
or

	SagepayServer.mode = :simulator # Use the simulator

Copyright (c) 2009 Go Tripod Ltd, released under the MIT license