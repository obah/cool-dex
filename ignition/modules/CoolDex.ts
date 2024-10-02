import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const CoolDexModule = buildModule("CoolDexModule", (m) => {
  const CoolDex = m.contract("CoolDex", []);

  return { CoolDex };
});

export default CoolDexModule;
