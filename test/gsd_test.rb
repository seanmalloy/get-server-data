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

gem 'minitest'
require 'minitest/autorun'
require 'gsd'

class TestServerData < Minitest::Test
  def setup
    @server = ServerData.new('foohost.spmalloy.com')
  end

  def test_constructor
    assert_equal 'foohost.spmalloy.com', @server.hostname
    assert_equal 22, @server.port
    assert_nil @server.dns_record_type
    assert_nil @server.ip
    assert_nil @server.port_status

    test_http_port = ServerData.new('foohost.spmalloy.com', 80)
    assert_equal 80, test_http_port.port
  end

  def test_method_port_status
    # open port on a host that exists
    host = ServerData.new('www.google.com', 80)
    host.port_status!
    assert host.port_status

    # closed port on a host that exists
    host = ServerData.new('www.google.com', 22)
    host.port_status!
    refute host.port_status

    # host does not exist
    @server.port_status!
    refute @server.port_status
  end

  def test_method_ip
    # hostname not in dns 
    @server.ip!
    refute @server.ip

    # hostname in dns
    host = ServerData.new('localhost', 80)
    host.ip!
    refute_nil host.ip
  end

  def test_method_dns_record_type
    # hosts not in DNS will be nil
    @server.dns_record_type!
    refute @server.dns_record_type
    
    # DNS A Record
    arecord = ServerData.new('spmalloy.com', 22)
    arecord.dns_record_type!
    assert_equal 'A', arecord.dns_record_type

    # DNS CNAME
    cname = ServerData.new('www.spmalloy.com', 22)
    cname.dns_record_type!
    assert_equal 'CNAME', cname.dns_record_type
  end
end

