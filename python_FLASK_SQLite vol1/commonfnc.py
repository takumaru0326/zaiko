import math 

def pagen(vntres,vntpageorigin,pagesuu):
    #vntpageorigin = vntpageorigin
    pageend = math.ceil(len(vntres)/pagesuu)
    pagelen = len(vntres)
    if vntpageorigin == pageend: 
        vntresult = vntres[(vntpageorigin)*pagesuu: pagelen]
    else:
        vntresult = vntres[(vntpageorigin)*pagesuu: (vntpageorigin + 1)*pagesuu]
     
    return vntresult,pageend,pagelen