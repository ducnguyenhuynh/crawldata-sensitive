work_dir=`pwd`
day=`date +"%Y%m%d"`

. ${work_dir}/list_useragent.sh
u_a=0 


maxLoops=5
Tab="    "
commonLink=""

mkdir -p ${work_dir}/${day}

# function downloadListElementsPage {
#     loop=0
#     category=$1
#     #get links of elements
    
# }

function downloadListElementsPage {
    loop=0
    category=$1
    cpage=$2
    awk -f get_elements.awk ${cpage} > extract.tab
    if [ ! -d ${work_dir}/${day}/$category/elements ]
    then
        mkdir ${work_dir}/${day}/$category/elements
    fi
    while read line 
    do 
        link_element=$line
        id=$(echo $link_element | awk '{n=split($0,a,"/");printf a[n-1]}')
        if [ ! -s ${work_dir}/${day}/${category}/elements/${id}.html ]
        then 
            u_a=$(( ( RANDOM % 400 )  + 1 ))
            wget -c -nv --timeout=15 --tries=5 --waitretry=1 -U"${USERAGENT_ARR[$u_a]}" --random-wait --keep-session-cookies --save-cookies=${work_dir}/${day}/cookies.$$ ${link_element} -O ${work_dir}/${day}/${category}/elements/${id}.html
        fi 

        # Check if the file was downloaded successfully
        grep -i "<\/html>" ${work_dir}/${day}/${category}/elements/${id}.html
        if [ $? -ne 0 ]
        then
            rm -f ${work_dir}/${day}/${category}/elements/${id}.html
            let "loop=loop+1"
        else
            loop=${maxLoops}
            echo "Download page $link_element successfully."
        fi

    done < extract.tab
}

function downloadListModePage {
    loop=0
    category=$1
    page=$2
    clink=$3
    while [ ${loop} -lt ${maxLoops} ]
    do 
        if [ ! -s ${work_dir}/${day}/${category}/page-${page}.html ]
        then 
            u_a=$(( ( RANDOM % 400 )  + 1 ))
            wget -c -nv --timeout=15 --tries=5 --waitretry=1 -U"${USERAGENT_ARR[$u_a]}" --random-wait --keep-session-cookies --save-cookies=${work_dir}/${day}/cookies.$$ ${clink} -O ${work_dir}/${day}/${category}/page-${page}.html
        fi 

        # Check if the file was downloaded successfully
        grep -i "<\/html>" ${work_dir}/${day}/${category}/page-${page}.html
        if [ $? -ne 0 ]
        then
            rm -f ${work_dir}/${day}/${category}/page-${page}.html
            let "loop=loop+1"
        else
            loop=${maxLoops}
            echo "Download page $clink successfully."
        fi
    done 
    echo "Downloading elements of page"
    downloadListElementsPage ${category} ${work_dir}/${day}/${category}/page-${page}.html
}


function downloadListModeCategory {
    page=$1
    awk -f get_categories.awk ${page} > category_link.tab
    while read line 
    do 
        loop=0
        link=$line
        category=$(echo $link | awk '{n=split($0,a,"/");printf a[n]}')
        echo $category
        if [ ! -d ${work_dir}/${day}/$category ]
        then
            mkdir ${work_dir}/${day}/$category
        fi
        # download category root pages
        while [ ${loop} -lt ${maxLoops} ]
        do
            if [ ! -s ${work_dir}/${day}/$category.html ]
            then
                 wget -c -nv --timeout=15 --tries=5 --waitretry=1 -U"${USERAGENT_ARR[$u_a]}" --random-wait --keep-session-cookies --save-cookies=${work_dir}/${day}/cookies.$$ ${link} -O ${work_dir}/${day}/${category}.html
            fi
            grep -i "<\/html>" ${work_dir}/${day}/$category.html
            if [ $? -ne 0 ]
            then
                rm -f ${work_dir}/${day}/root.html
                let "loop=loop+1"
            else
                loop=${maxLoops}
                # echo "Download page $category successfully."
            fi
        done
        #get number of pages
        nbpages=$(awk -f get_number_pages.awk ${work_dir}/${day}/$category.html)
        
        page=0
        echo $link
        while [ ${page} -le ${nbpages} ]
        do
            let "page=page+1"
            commonLink=${link}
            downloadListModePage $category ${page} ${commonLink}"/page/${page}"
        done 

    done < category_link.tab
}

function downloadListCategoryPage {
    loop=0
    rootPage=$1
    while read line
    do
        rlink=$line
        while [ ${loop} -lt ${maxLoops} ]
        do 
            if [ ! -s ${work_dir}/${day}/root.html ]
            then
                wget -c -nv --timeout=15 --tries=5 --waitretry=1 -U"${USERAGENT_ARR[$u_a]}" --random-wait --keep-session-cookies --save-cookies=${work_dir}/${day}/cookies.$$ ${rlink} -O ${work_dir}/${day}/root.html
            fi
            grep -i "<\/html>" ${work_dir}/${day}/root.html
            if [ $? -ne 0 ]
            then
                rm -f ${work_dir}/${day}/root.html
                let "loop=loop+1"
            else
                loop=${maxLoops}
                echo "Download page $rlink successfully."
            fi
        done
        downloadListModeCategory ${work_dir}/${day}/root.html
    done < $rootPage
    
}


# -------------------------------------------------------------------------------
# Main program 
# -------------------------------------------------------------------------------
downloadListCategoryPage ${work_dir}/root_link.tab
