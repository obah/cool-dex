import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const CoolDexModule = buildModule("CoolDexModule", (m) => {
  const CoolDex = m.contract("CoolDex", []);

  return { CoolDex };
});

export default CoolDexModule;

//link: https://sepolia-blockscout.lisk.com/address/0x9269252D4F1ebc69104534e82586f65C9CF3e605#code
//addr: 0x9269252D4F1ebc69104534e82586f65C9CF3e605
