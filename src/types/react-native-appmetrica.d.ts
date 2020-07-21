declare module "react-native-appmetrica" {
	export type AppMetricaConfig = {
		apiKey: string,
		appVersion?: string,
		crashReporting?: boolean,
		firstActivationAsUpdate?: boolean,
		location?: Location,
		locationTracking?: boolean,
		logs?: boolean,
		sessionTimeout?: number,
		statisticsSending?: boolean,
		preloadInfo?: PreloadInfo,
		// Only Android
		installedAppCollecting?: boolean,
		maxReportsInDatabaseCount?: number,
		nativeCrashReporting?: boolean,
		// Only iOS
		activationAsSessionStart?: boolean,
		sessionsAutoTracking?: boolean,
	}
	export type PreloadInfo = {
		trackingId: string,
		additionalInfo?: Object,
	}
	export type Location = {
		latitude: number,
		longitude: number,
		altitude?: number,
		accuracy?: number,
		course?: number,
		speed?: number,
		timestamp?: number,
	}

	export type AppMetricaDeviceIdReason = "UNKNOWN" | "NETWORK" | "INVALID_RESPONSE"

	const AppMetricaBridge: {
		activate(config: AppMetricaConfig): void
		getLibraryApiLevel(): Promise<number>
		getLibraryVersion(): Promise<string>
		pauseSession(): void
		reportAppOpen(deeplink?: string): void,
		reportError(error: string, reason: Object): void
		reportEvent(eventName: string, attributes?: Object): void
		reportReferralUrl(referralUrl: string): void
		requestAppMetricaDeviceID(listener: (deviceId?: String, reason?: AppMetricaDeviceIdReason) => void): void
		resumeSession(): void
		sendEventsBuffer(): void
		setLocation(location?: Location): void
		setLocationTracking(enabled: boolean): void
		setStatisticsSending(enabled: boolean): void
		setUserProfileID(userProfileID?: string): void
	}
	// eslint-disable-next-line import/no-default-export
	export default AppMetricaBridge
}
