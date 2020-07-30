package com.roboroxappmetrica

import com.facebook.react.bridge.*
import com.yandex.metrica.YandexMetrica
import com.yandex.metrica.profile.Attribute
import com.yandex.metrica.profile.UserProfile
import java.util.*
import kotlin.Boolean
import kotlin.Long
import kotlin.String


class AppmetricaModule(reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {
    override fun getName(): String {
        return "RoboroxAppmetrica"
    }

    @ReactMethod
    fun reportUserProfile(profile: ReadableMap) {
      val builder = UserProfile.newBuilder()
      for ((key, value) in profile.entryIterator) {
        builder.apply(
          when (key) {
            "name" -> value?.let { Attribute.name().withValue(value as String) }
              ?: Attribute.name().withValueReset()
            "gender" -> throw IllegalArgumentException("Can not change gender")
            "age" -> value?.let { Attribute.birthDate().withAge(value as Int) }
              ?: Attribute.birthDate().withValueReset()
            "birthDate" -> value?.let {
              Attribute.birthDate().withBirthDate(Calendar.getInstance().also { it.time = Date(value as Long) })
            } ?: Attribute.birthDate().withValueReset()
            "notificationsEnabled" -> value?.let { Attribute.notificationsEnabled().withValue(value as Boolean) }
              ?: Attribute.notificationsEnabled().withValueReset()
            else -> when (value) {
              is Boolean -> Attribute.customBoolean(key).withValue(value)
              is Double -> Attribute.customNumber(key).withValue(value)
              is String -> if (value.startsWith("+") || value.startsWith("-")) {
                Attribute.customCounter(key).withDelta(value.toDouble())
              } else {
                Attribute.customString(key).withValue(value)
              }
              else -> throw IllegalArgumentException("Unsupported prop type: $key")
            }
          }
        )
      }

      YandexMetrica.reportUserProfile(builder.build())
    }
}
