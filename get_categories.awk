BEGIN{
    i=0
}
/<a class="sort_category"/{
    split($0,arr,"=")
    split(arr[4],href,"\"")
    nbSubtrees[i]=href[2]
    i++
}
END{
    max_i=i
    for (i=1;i<max_i;i++){
        printf nbSubtrees[i]
        printf "\n"
    }
}