BEGIN{
    nbPages=0
}

/page-numbers/{
    n=split($0, temp,"page-numbers")
    split(temp[n-1],temp2,">")
    split(temp2[2],string_nbpages,"<")
    sub(",","",string_nbpages[1])
}
END{
    nbPages=string_nbpages[1]+0
    printf nbPages
}