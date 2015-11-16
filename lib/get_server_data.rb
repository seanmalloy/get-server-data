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

# Models server data (hostname, port, IP address, etc.)
class ServerData
  # Create ServerData object
  #
  # @param h [String] hostname
  # @param p [Integer] port number
  def initialize(h, p = 22)
    @dns_record_type = nil
    @hostname        = h
    @ip              = nil
    @port            = p
    @ping_status     = nil
    @port_status     = nil
  end

  # @!attribute [r] dns_record_type
  # @return [String] dns record type, "A" or "CNAME"
  attr_reader :dns_record_type

  # @!attribute [r] hostname
  # @return [String] hostname
  attr_reader :hostname

  # @!attribute [r] ip
  # @return [String] IP address
  attr_reader :ip

  # @!attribute [r] port
  # @return [Integer] port number
  attr_reader :port

  # @!attribute [r] ping_status
  # @return [Boolean] result of ping test
  attr_reader :ping_status

  # @!attribute [r] port_status
  # @return [Boolean] result of TCP port test
  attr_reader :port_status

  # Convert IP address to hostname
  #
  # @param input [String] IP address
  # @return [String] hostname from DNS
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

  # Check TCP port connectivity
  #
  # @param timeout [Integer] TCP timeout in seconds
  # @return [Boolean] success for failure of TCP connection
  def get_port_status(timeout = 1)
    begin
      Timeout::timeout(timeout) do
        begin
          s = TCPSocket.new(@hostname, @port)
          s.close
          return @port_status = true
        rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH, SocketError
          return @port_status = false
        end
      end
    rescue Timeout::Error
    end
    @port_status = false
  end 

  # Lookup server IP from DNS
  #
  # @return [String] IP address of the server
  def get_ip
    begin
      @ip = Resolv.getaddress(@hostname)
    rescue Resolv::ResolvError
      @ip = ""
    end
    @ip
  end

  # Lookup DNS record type
  #
  # @return [String] record type, "A" or "CNAME"
  def get_dns_type
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
    @dns_record_type
  end

  # Check ICMP connectivity
  #
  # @param timeout [Integer] ICMP timeout in seconds
  # @return [Boolean] success or failure of ICMP test
  def ping(timeout = 1)
    ping = Net::Ping::External.new(@hostname, 7, timeout)
    if ping.ping.nil?
      @ping_status = false
    else
      @ping_status = ping.ping
    end
    @ping_status
  end
end

