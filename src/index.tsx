import { NativeModules } from "react-native"
import RNYandexAppMetrica from "react-native-appmetrica"

const ExYandexAppMetrica: {
	reportUserProfile(profile: object): void
} = NativeModules.YandexAppMetrica

export * from "react-native-appmetrica"

type Time = number | [number, number?, number?] | null

export type UserProfile = {
	name?: string | null,
	age?: number | null,
	birthDate?: Time | { (): Time } | { getTime(): Time },
	notificationsEnabled?: boolean | null,
} & {
	[key: string]: boolean | number | string,
}

export const YandexAppMetrica = {
	...RNYandexAppMetrica,
	async requestAppMetricaDeviceID() {
		return new Promise<string>((resolve, reject) => {
			RNYandexAppMetrica.requestAppMetricaDeviceID((deviceID, reason) => {
				if (deviceID) resolve(deviceID.toString())
				else reject(reason)
			})
		})
	},
	reportUserProfile(profile: UserProfile) {
		if ("birthDate" in profile && profile.birthDate) {
			if (typeof profile.birthDate === "function") {
				profile.birthDate = profile.birthDate()
			} else if (
				typeof profile.birthDate === "object"
				&& "getTime" in profile.birthDate
			) {
				profile.birthDate = profile.birthDate.getTime()
			}
		}
		ExYandexAppMetrica.reportUserProfile(profile)
	},
}
