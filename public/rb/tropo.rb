require "net/http"
require "uri"

MAX_LENGTH = 160 * 4 # 4 SMS messages max

# Send a restful request to freexchange
url = URI.parse("http://freexchange.heroku.com/searches/finditem.text/?item=" + URI.escape($currentCall.initialText, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]")))

# Only bother if it's a text-based message (not VOICE)
# FIXME: how do we deal with VOICE calls?
if ($currentCall.channel == "TEXT")
    req = Net::HTTP::Get.new(url.path)
    res = Net::HTTP.start(url.host, url.port) {|http|
      http.request(req)
    }

    # FIXME: catch response errors

    # put a reasonable limit on the amount of text we sent back
    resp_body = res.body
    if (resp_body.length > MAX_LENGTH)
        resp_body = resp_body[0, MAX_LENGTH]
    end
    say(resp_body)
end


