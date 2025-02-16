package id.my.kanggara.demo;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * @author KAnggara [idstr.kelvin@xl.co.id] on Sat 15/02/25 08.52
 * @project mvn id.my.kanggara.demo
 */
@RestController
public class Controller {
    @GetMapping("api/test")
    public ResponseEntity<?> index() {
        return ResponseEntity.status(202).body("OK");
    }
}
