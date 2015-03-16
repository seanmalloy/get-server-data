# Copyright (c) 2015, Sean Malloy
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#
# 3. Neither the name of the copyright holder nor the names of its contributors
#    may be used to endorse or promote products derived from this software without
#    specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR
# IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
# AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
# IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
# OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

require 'coveralls'
Coveralls.wear!

gem 'minitest'
require 'minitest/autorun'
require 'gsd'
require 'resolv'

class TestServerData < Minitest::Test
  def setup
    @server = ServerData.new('foohost.spmalloy.com')
  end

  def test_constructor
    assert_instance_of ServerData, @server, 'ServerData.new creates instances of type ServerData'
    assert_nil @server.dns_record_type, 'ServerData.new sets dns_record_type to nil'
    assert_equal 'foohost.spmalloy.com', @server.hostname, 'ServerData.new sets hostsname'
    assert_nil @server.ip, 'ServerData.new sets ip to nil'
    assert_nil @server.ping_status, 'ServerData.new sets ping_status to nil'
    assert_equal 22, @server.port, 'ServerData.new sets port to 22'
    assert_nil @server.port_status, 'ServerData.new sets port_status to nil'

    test_http_port = ServerData.new('foohost.spmalloy.com', 80)
    assert_equal 80, test_http_port.port, 'ServerData.new can set port'
  end

  def test_method_hostname
    assert_respond_to @server, 'hostname', 'ServerData instance responds to hostname'
  end

  def test_method_port
    assert_respond_to @server, 'port', 'ServerData instance responds to port'
  end

  def test_method_port_status
    assert_respond_to @server, 'port_status', 'ServerData instance responds to port_status'
    assert_respond_to @server, 'port_status!', 'ServerData instance responds to port_status!'

    # open port on a host that exists
    host = ServerData.new('www.google.com', 80)
    host.port_status!
    assert host.port_status, 'verify port 80 status to www.google.com'

    # closed port on a host that exists
    host = ServerData.new('www.google.com', 22)
    host.port_status!
    refute host.port_status, 'verify port 22 status to www.google.com'
    refute_nil host.port_status, 'verify port_status is not nil when connection fails'

    # host does not exist
    @server.port_status!
    refute @server.port_status, 'verify port_status when connecting to host not in DNS'
    refute_nil @server.port_status, 'verify port_status is not nil when connecting to host not in dns'
  end

  def test_method_ip
    assert_respond_to @server, 'ip', 'ServerData instance responds to ip'
    assert_respond_to @server, 'ip!', 'ServerData instance responds to ip!'


    # hostname not in dns 
    @server.ip!
    refute @server.ip, 'verify ip for a hostname not in dns'
    refute_nil @server.ip, 'verify ip is not nil for a hostname not in dns'

    # hostname in dns
    host = ServerData.new('localhost', 80)
    host.ip!
    refute_nil host.ip, 'verify ip for localhost'
    assert(host.ip =~ Resolv::IPv4::Regex || host.ip =~ Resolv::IPv6::Regex, 'verify ip regex for localhost')
  end

  def test_method_dns_record_type
    assert_respond_to @server, 'dns_record_type', 'ServerData instance responds to dns_record_type'
    assert_respond_to @server, 'dns_record_type!', 'ServerData instance responds to dns_record_type!'

    # hosts not in DNS will be false
    @server.dns_record_type!
    refute @server.dns_record_type, 'verify dns_record_type for host not in dns'
    refute_nil @server.dns_record_type, 'verify dns_record_type is not nil for host not in dns'
    
    # DNS A Record
    arecord = ServerData.new('spmalloy.com', 22)
    arecord.dns_record_type!
    assert_equal 'A', arecord.dns_record_type, 'verify dns_record_type for a dns A record'

    # DNS CNAME
    if ENV['TRAVIS_CI_BUILD']
      skip 'skipping CNAME tests in Travis CI'
    else
      cname = ServerData.new('www.spmalloy.com', 22)
      cname.dns_record_type!
      assert_equal 'CNAME', cname.dns_record_type, 'verify dns_record_type for a dns CNAME record'
    end
  end

  def test_ping_status
    assert_respond_to @server, 'ping_status', 'ServerData instance responds to ping_status'
    assert_respond_to @server, 'ping_status!', 'ServerData instance responds to ping_status'

    # test result on a server not in dns
    @server.ip!
    @server.ping_status!
    refute @server.ping_status, 'verify ping_status for host not in dns'
    refute_nil @server.ping_status, 'verify ping_status is not nil for host not in dns'

    # test result from successful ping
    host = ServerData.new('localhost')
    host.ip!
    host.ping_status!
    assert host.ping_status, 'verify ping_status for localhost'
  end
end

