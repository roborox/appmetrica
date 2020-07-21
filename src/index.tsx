import { NativeModules } from 'react-native';

type AppmetricaType = {
  multiply(a: number, b: number): Promise<number>;
};

const { Appmetrica } = NativeModules;

export default Appmetrica as AppmetricaType;
