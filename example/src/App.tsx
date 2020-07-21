/* eslint-disable unicorn/filename-case */
import * as React from "react"
import { StyleSheet, View, Text } from "react-native"
import { YandexAppMetrica } from "@roborox/appmetrica"

export function App() {
	const [result, setResult] = React.useState<number | undefined>()

	React.useEffect(() => {
		YandexAppMetrica.activate({ apiKey: "BLAH" })
		YandexAppMetrica.reportUserProfile({
			blah: "asd",
		})
	}, [])

	return (
		<View style={styles.container}>
			<Text>Result: {result}</Text>
		</View>
	)
}

const styles = StyleSheet.create({
	container: {
		flex: 1,
		alignItems: "center",
		justifyContent: "center",
	},
})
