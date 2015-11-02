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

require 'net/ping'
require 'resolv'
require 'socket'
require 'timeout'

class ServerData
  def initialize(h, p = 22)
    @dns_record_type = nil
    @hostname        = h
    @ip              = nil
    @port            = p
    @ping_status     = nil
    @port_status     = nil
  end

  attr_reader :dns_record_type
  attr_reader :hostname
  attr_reader :ip
  attr_reader :port
  attr_reader :ping_status
  attr_reader :port_status

  # convert input into a hostname
  def self.to_hostname(input)
    if input =~ /^\d+\.\d+\.\d+.\d+$/
      begin
        return Resolv.getname(input)
      rescue Resolv::ResolvError
        return input
      end
    else
      return input
    end
  end

  def port_status!(timeout = 1)
    begin
      Timeout::timeout(timeout) do
        begin
          s = TCPSocket.new(@hostname, @port)
          s.close
          @port_status = true
          return true
        rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH, SocketError
          @port_status = false
          return false
        end
      end
    rescue Timeout::Error
    end
    @port_status = false
    return false
  end 

  def ip!
    begin
      @ip = Resolv.getaddress(@hostname)
    rescue Resolv::ResolvError
      @ip = false
    end
  end

  def dns_record_type!
    resolver = Resolv::DNS.new
    begin
      resolver.getresource(@hostname, Resolv::DNS::Resource::IN::CNAME)
    rescue Resolv::ResolvError
      # do nothing
    else
      @dns_record_type = 'CNAME'
    end

    if @dns_record_type.nil?
      begin
        resolver.getresource(@hostname, Resolv::DNS::Resource::IN::A)
      rescue Resolv::ResolvError
        @dns_record_type = false
      else
        @dns_record_type = 'A'
      end
    end
  end

  def ping_status!(timeout = 1)
    ping = Net::Ping::External.new(@hostname, 7, timeout)
    if ping.ping.nil?
      @ping_status = false
    else
      @ping_status = ping.ping
    end
  end
end

