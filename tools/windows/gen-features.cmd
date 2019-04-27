@pickles.exe -f ./../../features -l ru -o ./../../distr/ -df word --sn "Vanessa ADD"
@pickles.exe -f ./../../features -l ru -o ./../../distr/docs/dhtml -df dhtml --sn "Vanessa ADD"
@pickles.exe -f ./../../features -l ru -o ./../../distr/docs/html -df html --sn "Vanessa ADD"
@pandoc -f docx "./../../distr/Vanessa ADD.docx" -t markdown_github >> ./../../distr/FEATURES.md