require "net/http"

class GetPageRank
  @queue = "troch_worker_#{ENV['RAILS_ENV']}"

  def self.perform(site_id)
    site = Site.find(site_id)

    if site.url.blank? || site.url == "http://"
      page_rank = nil
    else
      url = site.url.scan(/(http:\/\/(\w|\.|!\/)+)/)
      url = (url.nil? || url[0].nil?) ? nil : url[0][0]

      trials = 0
      begin
        page_rank = GooglePageRank.get(url)
      rescue
        trials += 1
        retry if trials < 3
      end
    end
    site.page_rank_old = site.page_rank
    site.page_rank = page_rank
    site.save
  end
end

module GooglePageRank
  M=0x100000000 # modulo for unsigned int 32bit(4byte)
  def m1(a,b,c,d)
    return (((a+(M-b)+(M-c))%M)^(d%M))%M # mix/power mod
  end
  def c2i(s="",k=0)
    # char codes to int. Little Endian
    if RUBY_VERSION >= '1.9'
      s2 = []
      s2[k+3] = s[k+3].ord unless s[k+3].nil?
      s2[k+2] = s[k+2].ord unless s[k+2].nil?
      s2[k+1] = s[k+1].ord unless s[k+1].nil?
      s2[k+0] = s[k+0].ord unless s[k+0].nil?
      s = s2
    end
    return ((s[k+3].to_i*0x100+s[k+2].to_i)*0x100+s[k+1].to_i)*0x100+s[k].to_i
  end
  def mix(a,b,c)
    a=a%M; b=b%M; c=c%M
    a = m1(a,b,c, c >> 13); b = m1(b,c,a, a <<  8); c = m1(c,a,b, b >> 13)
    a = m1(a,b,c, c >> 12); b = m1(b,c,a, a << 16); c = m1(c,a,b, b >>  5)
    a = m1(a,b,c, c >>  3); b = m1(b,c,a, a << 10); c = m1(c,a,b, b >> 15)
    return [a,b,c]
  end
  def checkSum(url)
    a= 0x9E3779B9; b= 0x9E3779B9;
    c= 0xE6359A60; # Google Magic Number
    iurl="info:"+url; len = iurl.size; k=0
    while (len>=k+12) do
      a += c2i(iurl,k) ; b += c2i(iurl,k+4); c += c2i(iurl,k+8); a,b,c = mix(a,b,c)
      k=k+12
    end
    a += c2i(iurl,k); b += c2i(iurl,k+4); c += (c2i(iurl,k+8)<<8)+len; a,b,c = mix(a,b,c)
    return c
  end

  def get(url, port=80)
    ch = sprintf("6%u",checkSum(url))

    g_path=sprintf("/tbr?client=navclient-auto&features=Rank&q=info:%s&ch=%s", url, ch)

    p=-1 # pagerank
    g_server="toolbarqueries.google.com"  # toolbarqueries.google.co.jp  www.google.co.jp
    Net::HTTP.new(g_server, port).get(g_path){|line|
      pos=line.index("Rank_1:")
      if( pos != nil) then
        n=(line[pos+7,1]).to_i # digit
        p=(line[pos+9,n]).to_i # pagerank of n digit
        break;
      end;
    }
    return p
  end

  module_function :m1, :c2i, :mix
  module_function :checkSum, :get
end
