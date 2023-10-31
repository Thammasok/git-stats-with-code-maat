#!/usr/bin/env bash

if [ ${#@} -lt 1 ]; then
    echo "require at lease 1 parameter"
    echo "eg. xlog before(YYYY-MM-DD) : xlog 2018-10-21"
    echo "    xlog before(YYYY-MM-DD) after(YYYY-MM-DD) : xlog 2018-10-21 2018-01-21"
    exit 1
fi

if [ ${#@} -gt 1 ]; then
    DIRNAME=$2_$1
    PERIOD="--before=$1 --after=$2" 
    DIR="data/$DIRNAME"
elif [ ${#@} -gt 0 ]; then
    DIRNAME=$1
    PERIOD="--before=$1"
    DIR="data/$DIRNAME"
fi

[[ ! `ls -a $DIR` ]] && `mkdir -p $DIR`

eval "git log --pretty=format:'[%h] %an %ad %s' --date=short --numstat $PERIOD > $DIR/evo.log"

cloc ./ --by-file --csv --quiet --exclude-dir=vendor --report-file=$DIR/lines.csv

#git log --pretty=format:'[%h] %an %ad %s' --date=short --numstat --no-merges --no-renames --before=2013-06-01 --after=2013-01-01 > data/evo.log

# maat -l $DIR/evo*.log -c git > $DIR/authors-revisions.csv
# default -a = authors
maat -l $DIR/evo*.log -c git -a abs-churn > $DIR/abs-churn.csv
maat -l $DIR/evo*.log -c git -a age > $DIR/age.csv
maat -l $DIR/evo*.log -c git -a author-churn > $DIR/author-churn.csv
maat -l $DIR/evo*.log -c git -a authors > $DIR/authors.csv
maat -l $DIR/evo*.log -c git -a communication > $DIR/communication.csv
maat -l $DIR/evo*.log -c git -a coupling > $DIR/coupling.csv
maat -l $DIR/evo*.log -c git -a entity-churn > $DIR/entity-churn.csv
maat -l $DIR/evo*.log -c git -a entity-effort > $DIR/entity-effort.csv
maat -l $DIR/evo*.log -c git -a entity-ownership > $DIR/entity-ownership.csv
maat -l $DIR/evo*.log -c git -a fragmentation > $DIR/fragmentation.csv
maat -l $DIR/evo*.log -c git -a identity > $DIR/identity.csv
maat -l $DIR/evo*.log -c git -a main-dev > $DIR/main-dev.csv
maat -l $DIR/evo*.log -c git -a main-dev-by-revs > $DIR/main-dev-by-revs.csv
# maat -l $DIR/evo*.log -c git -a messages > $DIR/messages.csv
maat -l $DIR/evo*.log -c git -a refactoring-main-dev > $DIR/refactoring-main-dev.csv
maat -l $DIR/evo*.log -c git -a revisions > $DIR/revisions.csv
maat -l $DIR/evo*.log -c git -a soc > $DIR/soc.csv
maat -l $DIR/evo*.log -c git -a summary > $DIR/summary.csv

merge $DIR/revisions.csv $DIR/lines.csv > $DIR/comp-freqs.csv
