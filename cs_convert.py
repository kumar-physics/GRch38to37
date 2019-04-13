import json
from urllib.request import urlopen, Request
import sys

def cs_convert(chromosome,start,end,input_cs='GRch38',output_cs='GRch37'):
    url = 'https://rest.ensembl.org/map/human/{}/{}:{}..{}/{}?content-type=application/json'.format(
        input_cs,chromosome,start,end,output_cs)
    url_req = Request(url)
    r = urlopen(url_req)
    data = json.loads(r.read())
    print ('   {}          {}'.format(input_cs,output_cs))
    for maps in data['mappings']:
        print ('{}..{} => {}..{}'.format(maps['original']['start'],maps['original']['end'],
                                         maps['mapped']['start'],maps['mapped']['end']))


if __name__ == "__main__":
    ch = sys.argv[1]
    start = sys.argv[2]
    end = sys.argv[3]
    input_cs = sys.argv[4]
    output_cs = sys.argv[5]
    cs_convert(ch,start,end,input_cs,output_cs)