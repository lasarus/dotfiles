FILE=$(mktemp --suffix=.png)
scrot -s $FILE

ans=$(zenity  --list  --text "What do you want to do with the image?" --checklist  --column "Pick" --column "Action" FALSE "Save as" TRUE Imgur FALSE Gimp FALSE "feh")

IFS='|'
for v in $ans
do
    case "$v" in
	"Imgur")
	    /home/lucas/.scripts/imgurbash.sh $FILE | zenity --text-info --filename /dev/stdin
	    ;;
	"Gimp")
	    gimp $FILE
	    ;;
	"Save as")
	    output=$(zenity --file-selection --save --filename="screenshot_$(date --iso).png")
	    cp $FILE $output
	    FILE=$output
	    ;;

	"feh")
	    feh $FILE
	    ;;

	*)
    esac
done
