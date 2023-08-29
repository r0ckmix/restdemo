package org.openapitools.api

import org.springframework.beans.factory.annotation.Autowired
import org.springframework.core.env.Environment
import org.springframework.http.ResponseEntity
import org.springframework.validation.annotation.Validated
import org.springframework.web.bind.annotation.*

@RestController
@Validated
@RequestMapping("\${api.base-path:}")
class HelloApiController() {


    @Autowired
    private val env: Environment? = null

    @RequestMapping(
        method = [RequestMethod.GET],
        value = ["/hello"],
        produces = ["text/plain"]
    )
    fun helloGet(): ResponseEntity<kotlin.String> {
        val sInstanceName: String = env?.getProperty("INSTANCE_NAME") ?: ""
        return ResponseEntity.ok("Hi!\nI amm $sInstanceName!")
    }
}
