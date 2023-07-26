#!/bin/bash
#Copyright (c) 2023 Divested Computing Group
#
#This program is free software: you can redistribute it and/or modify
#it under the terms of the GNU General Public License as published by
#the Free Software Foundation, either version 3 of the License, or
#(at your option) any later version.
#
#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.
#
#You should have received a copy of the GNU General Public License
#along with this program.  If not, see <https://www.gnu.org/licenses/>.

function resolveHost(){
	local resolver="$1";
	local domain="$2";
	response=$(dig "$resolver" +short A "$domain");
	if [ "$?" == 0 ] && [ -z "$response" ]; then
		#echo "$domain - no response";
		return 1;
	else
		#echo "$domain - $response";
		return 0;
	fi; 
}
export -f resolveHost;

function testResolver(){
	local resolver="$1";
	local domainList="$2";
	local prettyname="$3";
	local name="$resolver";
	if [ -n "$prettyname" ]; then name="$prettyname"; fi;
	local countPositive=0;
	local countNegative=0;
	while read line; do
		if [ -f "0ABORT0" ]; then break; fi;
		if resolveHost "$resolver" "$line"; then
			countPositive=$((countPositive+1));
		else
			countNegative=$((countNegative+1));
		fi;
	done < "$domainList";
	echo -e "Results for $name against $domainList:\n\tResolved: $countPositive\n\tUnresolved: $countNegative" | tee -a "results/$resultTime/$name.txt";
}
export -f testResolver;

function runAllLists(){
	local resolver="$1";
	local prettyname="$2";
	testResolver "$resolver" "domains-good.txt" "$prettyname";
	testResolver "$resolver" "domains-bad-abusech-shuf.txt" "$prettyname";
	testResolver "$resolver" "domains-bad-certpl-shuf.txt" "$prettyname";
	testResolver "$resolver" "domains-bad-disconnect_ads-shuf.txt" "$prettyname";
}
export -f runAllLists;

function runAllTests(){
	shuffleBad 50;
	export resultTime=$(date +%s);
	mkdir -p "results/$resultTime";

	runAllLists "@8.8.8.8" "Google" &

	runAllLists "@1.1.1.1" "Cloudflare" &
	runAllLists "@1.1.1.2" "Cloudflare (Security)" &

	runAllLists "@9.9.9.10" "Quad9 (nonblocking)" &
	runAllLists "@9.9.9.9" "Quad9" &

	runAllLists "@193.110.81.0" "DNS0" &
	runAllLists "@193.110.81.9" "DNS0 (ZERO)" &

	runAllLists "@94.140.14.140" "AdGuard (nonblocking)" &
	runAllLists "@94.140.14.14" "AdGuard" &

	runAllLists "@64.6.64.6" "Neustar (nonblocking)" &
	runAllLists "@156.154.70.2" "Neustar" &

	runAllLists "@77.88.8.8" "Yandex" &
	runAllLists "@77.88.8.88" "Yandex (Safe)" &

	echo "Started all tests in background";
}
export -f runAllTests;

function collateResults(){
	if [ -n "$resultTime" ]; then
		echo "last updated: $(date -uI -d @$resultTime)" > results/$resultTime.txt;
		cat results/$resultTime/*.txt >> results/$resultTime.txt;
	else
		echo "results unavailable";
	fi;
}
export -f collateResults;

function haltTests(){
	touch 0ABORT0;
	echo "Remember to remove the abort file before running again";
}
export -f haltTests;

function shuffleBad(){
	shuf -n "$1" "domains-bad-abusech.txt" > "domains-bad-abusech-shuf.txt";
	shuf -n "$1" "domains-bad-certpl.txt" > "domains-bad-certpl-shuf.txt";
	shuf -n "$1" "domains-bad-disconnect_ads.txt" > "domains-bad-disconnect_ads-shuf.txt";
	dos2unix domains-bad*.txt; #Fixup
}
export -f shuffleBad;

function downloadLists(){
	wget "https://urlhaus.abuse.ch/downloads/hostfile/" -O - | grep -i -v -e '^#' | sed 's|127.0.0.1\t||' > "domains-bad-abusech.txt";
	wget "https://hole.cert.pl/domains/domains.txt" -O "domains-bad-certpl.txt";
	wget "https://s3.amazonaws.com/lists.disconnect.me/simple_ad.txt" -O - | grep -i -v -e '^#' | sed '/^$/d' > "domains-bad-disconnect_ads.txt";
	dos2unix domains-bad*.txt; #Fixup
}
export -f downloadLists;
