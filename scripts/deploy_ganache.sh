# === DEFINE MODULES ===
# ==== External ====

# ===== Tokens ====
export EXT_TOKEN_DAI=0x5592EC0cfb4dbc12D3aB100b257153436a1f0FEa
export EXT_TOKEN_USDC=0x4DBCdF9B62e891a7cec5A2568C3F4FAF9E8Abe2b
export EXT_TOKEN_AKRO=0xad7541B1E795656851caD5c70aA8d495063D9a95
export EXT_TOKEN_ADEL=0x4d7af020D42D3E1a3C0CaE7A8e56127a05EF5e5f

# ===== Compound ====
export EXT_COMPOUND_CTOKEN_DAI=0x6D7F0754FFeb405d23C51CE938289d4835bE3b14
export EXT_COMPOUND_CTOKEN_USDC=0x5B281A6DdA0B271e91ae35DE655Ad301C976edb1
export EXT_COMPOUND_COMPTROLLER=0xD9580ad2bE0013A3a8187Dc29B3F63CDC522Bde7

# ===== Curve.Fi ====
export EXT_CURVEFY_Y_DEPOSIT=0xE58e27F0D7aADF7857dbC50f9f471eFa54E15178
export EXT_CURVEFY_Y_REWARDS=0x3a24cd58e76b11c5d8fd48215c721e8aa885b1d8
export EXT_CURVEFY_SBTC_DEPOSIT=0xE639834AC3EBd7a24263eD5BdC38213bb4a8fdC6
export EXT_CURVEFY_SBTC_REWARDS=0x69f60335b0ead20169ef3bfd94cce73ce03b8c3e
export EXT_CURVEFY_SUSD_DEPOSIT=0x627E0ca4c14299ACE0383fC9CBb57634ef843499
export EXT_CURVEFY_SUSD_REWARDS=0x716312d5176aC683953d54773B87A6001e449fD6

# ==== Akropolis ====
export MODULE_POOL=0x6EBB74818ce42935143230038Eb5643fE3BE70B4
export MODULE_ACCESS=0x8463377055e5fB3c94e1086eDDeAb773E908c775
export MODULE_SAVINGS=0x9af83A92b7C5F6505506798096Ccbc179a495C4c
export MODULE_INVESTING=0x26ecd051a70e2cB39Dc1834aF07ABd12840479bf
export MODULE_STAKING=0x6887DF2f4296e8B772cb19479472A16E836dB9e0
export MODULE_STAKING_ADEL=0x1a80540930B869df525981c4231Cd06b0Dcbf668
export MODULE_REWARD=0x214eAB7667848ec753A50Bf98416a8E12D3516f2
export MODULE_REWARD_DISTR=0x586C698698f316D9f10332A4300859DD8A82B130

export PROTOCOL_CURVEFY_Y=0x1b19B5AE07b9414687A58BE6be9881641FB5F771
export POOL_TOKEN_CURVEFY_Y=0x84857Bb64950e7BC2DfEB8Cb69fb75F3f7512E8E

export PROTOCOL_CURVEFY_SBTC=
export POOL_TOKEN_CURVEFY_SBTC=

export PROTOCOL_CURVEFY_SUSD=0x3A52c1BB8651d8a73Ebf9E569AE5fe9b558Fcde1
export POOL_TOKEN_CURVEFY_SUSD=0x0ecaf0f8A287aC68dB7D45C65b4B15c0889cA819

export PROTOCOL_COMPOUND_DAI=0x853D71180E6bA6584f3D400b21E4aEe2463129A4
export POOL_TOKEN_COMPOUND_DAI=0x06C2119701B0034BFaC3Be3C65DAc35054404571

export PROTOCOL_COMPOUND_USDC=0x048E645BA2965F48d72e7b855D6636F951aeD303
export POOL_TOKEN_COMPOUND_USDC=0x551AaBC00A7d02b51A81138fb8fA455786720793

# === GOTO REQUESTED OP===
op=$1

# === ACTIONS ===
case $op in
        show)
                echo npx oz send-tx --to $PROTOCOL_COMPOUND_DAI --network development --method addDefiOperator --args $MODULE_REWARD_DISTR
                echo npx oz send-tx --to $PROTOCOL_COMPOUND_USDC --network development --method addDefiOperator --args $MODULE_REWARD_DISTR
                echo npx oz send-tx --to $PROTOCOL_CURVEFY_SUSD --network development --method addDefiOperator --args $MODULE_REWARD_DISTR
                ;;
        init)
                echo INIT PROJECT, ADD CONTRACTS
                # call npx oz init
                npx oz add Pool AccessModule SavingsModule StakingPool AKRO ADEL
                npx oz add CompoundProtocol_DAI PoolToken_Compound_DAI
                npx oz add CompoundProtocol_USDC PoolToken_Compound_USDC
                # call npx oz add CurveFiProtocol_Y PoolToken_CurveFiY
                # call npx oz add CurveFiProtocol_SBTC PoolToken_CurveFi_SBTC
                npx oz add CurveFiProtocol_SUSD PoolToken_CurveFi_SUSD
                ;;
        createPool)
                echo CREATE POOL
                npx oz create Pool --network development --init
                ;;

        createModules)
                echo CREATE MODULES

                npx oz create ADEL --network development --init "initialize()"
                npx oz create AKRO --network development --init "initialize()"

                npx oz create AccessModule --network development --init "initialize(address _pool)" --args $MODULE_POOL
                npx oz create SavingsModule --network development --init "initialize(address _pool)" --args $MODULE_POOL
#                npx oz create StakingPool --network development --init "initialize(address _pool,address _stakingToken, uint256 _defaultLockInDuration)" --args "$MODULE_POOL, $EXT_TOKEN_AKRO, 0"
#                npx oz create StakingPoolADEL --network development --init "initialize(address _pool,address _stakingToken, uint256 _defaultLockInDuration)" --args "$MODULE_POOL, $EXT_TOKEN_ADEL, 0"
#                npx oz create RewardVestingModule --network rinkeby --init "initialize(address _pool)" --args $MODULE_POOL
#                npx oz create RewardDistributionModule --network rinkeby --init "initialize(address _pool)" --args $MODULE_POOL
#                echo CREATE PROTOCOLS AND TOKENS
#                echo CREATE Compound DAI
#                npx oz create CompoundProtocol_DAI --network development --init "initialize(address _pool, address _token, address _cToken, address _comptroller)" --args "$MODULE_POOL, $EXT_TOKEN_DAI, $EXT_COMPOUND_CTOKEN_DAI, $EXT_COMPOUND_COMPTROLLER"
#                npx oz create PoolToken_Compound_DAI --network development --init "initialize(address _pool)" --args $MODULE_POOL
#                echo CREATE Compound USDC
#                npx oz create CompoundProtocol_USDC --network rinkeby --init "initialize(address _pool, address _token, address _cToken, address _comptroller)" --args "$MODULE_POOL, $EXT_TOKEN_USDC, $EXT_COMPOUND_CTOKEN_USDC, $EXT_COMPOUND_COMPTROLLER"
#                npx oz create PoolToken_Compound_USDC --network rinkeby --init "initialize(address _pool)" --args $MODULE_POOL
#                echo CREATE Curve.Fi Y
#                npx oz create CurveFiProtocol_Y --network rinkeby --init "initialize(address _pool)" --args $MODULE_POOL
#                npx oz create PoolToken_CurveFi_Y --network rinkeby --init "initialize(address _pool)" --args $MODULE_POOL
                # echo CREATE Curve.Fi SBTC
                # call npx oz create CurveFiProtocol_SBTC --network rinkeby --init "initialize(address _pool)" --args $MODULE_POOL
                # call npx oz create PoolToken_CurveFi_SBTC --network rinkeby --init "initialize(address _pool)" --args $MODULE_POOL
#                echo CREATE Curve.Fi SUSD
                #                npx oz create CurveFiProtocol_SUSD --network rinkeby --init "initialize(address _pool)" --args $MODULE_POOL
                #                npx oz create PoolToken_CurveFi_SUSD --network rinkeby --init "initialize(address _pool)" --args $MODULE_POOL
                ;;

        addModules)
                echo 'SETUP POOL: CALL FOR ALL MODULES (set)'
                npx oz send-tx --to $MODULE_POOL --network development --method set --args "access, $MODULE_ACCESS, false"
                npx oz send-tx --to $MODULE_POOL --network development --method set --args "savings, $MODULE_SAVINGS, false"
#                npx oz send-tx --to $MODULE_POOL --network rinkeby --method set --args "stakingAkro, %MODULE_STAKING%, false"
#                npx oz send-tx --to $MODULE_POOL --network rinkeby --method set --args "stakingAdel, %MODULE_STAKING_ADEL%, false"
#                npx oz send-tx --to $MODULE_POOL --network rinkeby --method set --args "reward, %MODULE_REWARD%, false"
#                npx oz send-tx --to $MODULE_POOL --network rinkeby --method set --args "rewardDistributions, %MODULE_REWARD_DISTR%, false"
#                npx oz send-tx --to $MODULE_POOL --network rinkeby --method set --args "akro, %EXT_TOKEN_AKRO%, false"
#                npx oz send-tx --to $MODULE_POOL --network rinkeby --method set --args "adel, %EXT_TOKEN_ADEL%, false"
                ;;
        *)
                ;;
esac

echo "DONE"
exit 0




:setupProtocols
echo SETUP OTHER CONTRACTS
# call npx oz send-tx --to %PROTOCOL_CURVEFY_Y% --network rinkeby --method setCurveFi --args "%EXT_CURVEFY_Y_DEPOSIT%, %EXT_CURVEFY_Y_REWARDS%"
# call npx oz send-tx --to %PROTOCOL_CURVEFY_SBTC% --network rinkeby --method setCurveFi --args "%EXT_CURVEFY_SBTC_DEPOSIT%, %EXT_CURVEFY_SBTC_REWARDS%"
npx oz send-tx --to %PROTOCOL_CURVEFY_SUSD% --network rinkeby --method setCurveFi --args "%EXT_CURVEFY_SUSD_DEPOSIT%, %EXT_CURVEFY_SUSD_REWARDS%"
goto :done

:addProtocols
echo ADD PROTOCOLS
npx oz send-tx --to %MODULE_SAVINGS% --network development --method registerProtocol --args "%PROTOCOL_COMPOUND_DAI%, %POOL_TOKEN_COMPOUND_DAI%"
npx oz send-tx --to %MODULE_SAVINGS% --network development --method registerProtocol --args "%PROTOCOL_COMPOUND_USDC%, %POOL_TOKEN_COMPOUND_USDC%"
# call npx oz send-tx --to %MODULE_SAVINGS% --network rinkeby --method registerProtocol --args "%PROTOCOL_CURVEFY_Y%, %POOL_TOKEN_CURVEFY_Y%"
# call npx oz send-tx --to %MODULE_SAVINGS% --network rinkeby --method registerProtocol --args "%PROTOCOL_CURVEFY_SBTC%, %POOL_TOKEN_CURVEFY_SBTC%"
npx oz send-tx --to %MODULE_SAVINGS% --network rinkeby --method registerProtocol --args "%PROTOCOL_CURVEFY_SUSD%, %POOL_TOKEN_CURVEFY_SUSD%"
goto :done

:setupOperators
echo SETUP OPERATORS FOR PROTOCOLS
npx oz send-tx --to %PROTOCOL_COMPOUND_DAI% --network rinkeby --method addDefiOperator --args %MODULE_SAVINGS%
npx oz send-tx --to %PROTOCOL_COMPOUND_USDC% --network rinkeby --method addDefiOperator --args %MODULE_SAVINGS%
# call npx oz send-tx --to %PROTOCOL_CURVEFY_Y% --network rinkeby --method addDefiOperator --args %MODULE_SAVINGS%
# call npx oz send-tx --to %PROTOCOL_CURVEFY_SBTC% --network rinkeby --method addDefiOperator --args %MODULE_SAVINGS%
npx oz send-tx --to %PROTOCOL_CURVEFY_SUSD% --network rinkeby --method addDefiOperator --args %MODULE_SAVINGS%
echo SETUP MINTERS FOR POOL TOKENS
npx oz send-tx --to %POOL_TOKEN_COMPOUND_DAI% --network rinkeby --method addMinter --args %MODULE_SAVINGS%
npx oz send-tx --to %POOL_TOKEN_COMPOUND_USDC% --network rinkeby --method addMinter --args %MODULE_SAVINGS%
# call npx oz send-tx --to %POOL_TOKEN_CURVEFY_Y% --network rinkeby --method addMinter --args %MODULE_SAVINGS%
# call npx oz send-tx --to %POOL_TOKEN_CURVEFY_SBTC% --network rinkeby --method addMinter --args %MODULE_SAVINGS%
npx oz send-tx --to %POOL_TOKEN_CURVEFY_SUSD% --network rinkeby --method addMinter --args %MODULE_SAVINGS%
goto :done

