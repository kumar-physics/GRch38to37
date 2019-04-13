import json
from urllib.request import urlopen, Request

def GRch38to37(chromosome,start,end,input_cs='GRch38',output_cs='GRch37'):
    url = 'https://rest.ensembl.org/map/human/{}/{}:{}..{}/{}?content-type=application/json'.format(
        input_cs,chromosome,start,end,output_cs)
    url_req = Request(url)
    r = urlopen(url_req)
    data = json.loads(r.read())
    print ('   GRch38          GRch37')
    for maps in data['mappings']:
        print ('{}..{} => {}..{}'.format(maps['original']['start'],maps['original']['end'],
                                         maps['mapped']['start'],maps['mapped']['end']))


if __name__ == "__main__":
    GRch38to37(10,25000,30000)