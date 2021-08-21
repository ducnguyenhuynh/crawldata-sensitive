BEGIN{
    i=0
    info[i]="URL";i++
    info[i]="TITLE"; i++
    info[i]="TAG";i++
    info[i]="IMAGES";i++
    info[i]="VIDEO";i++
    max_i=i
    nb_image=0
    nb_tag=0
}

/rel="tag"/{
    n=split($0,temptag,"rel=\"tag\"")
    if(n <= 2){
        split(temptag[2],temptag1,">")
        split(temptag1[2],temptag2,"<")
        tag[nb_tag]=temptag2[1]
        nb_tag++
    }
    else{
        for(j=2;j<=n;j++){
            split(temptag[j],temptag1,">")
            split(temptag1[2],temptag2,"<")
            tag[nb_tag]=temptag2[1]
            nb_tag++
        }
    }    
}
/title-sample-image/{
    getline
    getline
    getline
    getline
    split($0,tempimage,"\"")
    images[nb_image]=tempimage[2];nb_image++
    gsub("-1","-2",tempimage[2])
    images[nb_image]=tempimage[2];nb_image++
    gsub("-2","-3",tempimage[2])
    images[nb_image]=tempimage[2];nb_image++
    # print(images[2])
}
/canonical/{
    split($0,tempurl,"\"")
    url=tempurl[4]
}
/video-info small/{
    getline
    getline
    split($0,temptitle1,"<")
    split(temptitle1[2],temptitle2,">")
    title=temptitle2[2]
}
/id='video'/{
    split($0,tempvideo,"\'")
    video=tempvideo[4]
}

END{
    TAB="\t"
    # for(i=0;i<max_i-1;i++){
    #     printf info[i]TAB
    # }
    # printf info[max_i-1]"\n"

    printf url TAB title TAB 
    for(i=0;i<nb_tag;i++){
        printf tag[i]","
    }
    printf tag[nb_tag-1] TAB
    for(i=0;i<nb_image;i++){
        printf images[i]","
    }
    printf images[nb_image-1] TAB
    printf video"\n"
}