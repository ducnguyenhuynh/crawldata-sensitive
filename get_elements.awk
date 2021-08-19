BEGIN{
    i=0
}
/item-img loop-video/{
    getline
    split($0,temp, "href=\"")
    split(temp[2], temp1,"\"")
    nbElements[i]=temp1[1]
    i++
}
END{
    max_i=i
    for(i=0;i<max_i;i++){
        printf nbElements[i]
        printf "\n"
    }
}