package org.openapitools.api

//import jdk.nashorn.internal.objects.NativeRegExp.test
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Assertions.assertNotNull
import org.junit.jupiter.api.Test
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
//import kotlin.test

class HelloApiTest {

    private val api: HelloApiController = HelloApiController()

    /**
     * To test HelloApiController.helloGet
     *
     * @throws ApiException
     *          if the Api call fails
     */
    @Test
    fun helloGetTest() {
        val response: ResponseEntity<kotlin.String> = api.helloGet()

        //assertNotNull(null)
        assertNotNull(response)
        assertEquals(response.statusCode, HttpStatus.OK)
//        assertEquals(response.body, "Hi!")
        assert(response.body.startsWith("Hi!"))
    }
}