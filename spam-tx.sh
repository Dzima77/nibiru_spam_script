GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color
DELEGATOR=xxxxxxxx #account address
VALIDATOR=xxxxxxxx #validator address
PASWD=xxxxxx #account pass
DELAY=360 #in secs - how often restart the script 
ACC_NAME=xxxxxx #account name 
NODE=http://localhost:26657 #change it only if you use another rpc port of your node

for (( ;; )); do
        BAL=$(nibirud query bank balances ${DELEGATOR} --node ${NODE});
        echo -e "BALANCE: ${GREEN}${BAL}${NC} ugame\n"
        echo -e "Claim rewards\n"
        echo -e "${PASWD}\n${PASWD}\n" | nibirud tx distribution withdraw-rewards ${VALIDATOR} --chain-id neuron-1 --from ${ACC_NAME} --node ${NODE} --commission -y --fees 20ugame
        for (( timer=10; timer>0; timer-- ))
        do
                printf "* sleep for ${RED}%02d${NC} sec\r" $timer
                sleep 1
        done
        BAL=$(nibirud query bank balances ${DELEGATOR} --node ${NODE} -o json | jq -r '.balances | .[].amount');
        echo -e "BALANCE: ${GREEN}${BAL}${NC} ugame\n"
        echo -e "Stake ALL\n"
        echo -e "${PASWD}\n${PASWD}\n" | nibirud tx bank send ${ACC_NAME} ${DELEGATOR} 100ugame --chain-id neuron-1 --node ${NODE} -y --fees 50ugame
        for (( timer=63; timer>0; timer-- ))
        do
                printf "* sleep for ${RED}%02d${NC} sec\r" $timer
                sleep 1
        done
done
