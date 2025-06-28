CREATE DEFINER=`root`@`%` TRIGGER qqq1
AFTER INSERT
ON historial_graduaciones FOR EACH ROW
BEGIN
  DECLARE fecha_max DATE;
  SELECT MAX(fecha)
  INTO fecha_max
  FROM historial_graduaciones
  WHERE persona_id = NEW.persona_id;

  IF NEW.fecha = fecha_max THEN
    UPDATE personas
    SET graduacion_actual = NEW.graduacion_obtenida
    WHERE id = NEW.persona_id;
  END IF;
END;







-- Trigger: actualizar graduacion_actual en personas después de INSERT
CREATE TRIGGER actualizar_graduacion_actual
AFTER INSERT ON historial_graduaciones FOR EACH ROW
BEGIN
  DECLARE fecha_max DATE;
  SELECT MAX(fecha)
  INTO fecha_max
  FROM historial_graduaciones
  WHERE persona_id = NEW.persona_id;

  IF NEW.fecha = fecha_max THEN
    UPDATE personas
    SET graduacion_actual = NEW.graduacion_obtenida
    WHERE id = NEW.persona_id;
  END IF;
END;

-- Trigger: UPDATE en historial_graduaciones
CREATE TRIGGER recalcular_graduacion_actual_update
AFTER UPDATE ON historial_graduaciones
FOR EACH ROW
BEGIN
  DECLARE grad VARCHAR(50);
  SELECT graduacion
  INTO grad
  FROM historial_graduaciones
  WHERE persona_id = NEW.persona_id
  ORDER BY fecha DESC
  LIMIT 1;

  UPDATE personas
  SET graduacion_actual = grad
  WHERE id = NEW.persona_id;
END;

-- Trigger: DELETE en historial_graduaciones
CREATE TRIGGER recalcular_graduacion_actual_delete
AFTER DELETE ON historial_graduaciones
FOR EACH ROW
BEGIN
  DECLARE grad VARCHAR(50);
  SELECT graduacion
  INTO grad
  FROM historial_graduaciones
  WHERE persona_id = OLD.persona_id
  ORDER BY fecha DESC
  LIMIT 1;

  UPDATE personas
  SET graduacion_actual = grad
  WHERE id = OLD.persona_id;
END;

-- Trigger: actualizar dojo_actual_id al insertar participación en dojo
CREATE TRIGGER actualizar_dojo_actual_insert
AFTER INSERT ON personas_por_dojo
FOR EACH ROW
BEGIN
  DECLARE dojo_ultimo INT;
  SELECT dojo_id
  INTO dojo_ultimo
  FROM personas_por_dojo
  WHERE persona_id = NEW.persona_id
  ORDER BY desde_fecha DESC
  LIMIT 1;

  UPDATE personas
  SET dojo_actual_id = dojo_ultimo
  WHERE id = NEW.persona_id;
END;

-- Trigger: actualizar dojo_actual_id al hacer UPDATE
CREATE TRIGGER actualizar_dojo_actual_update
AFTER UPDATE ON personas_por_dojo
FOR EACH ROW
BEGIN
  DECLARE dojo_ultimo INT;
  SELECT dojo_id
  INTO dojo_ultimo
  FROM personas_por_dojo
  WHERE persona_id = NEW.persona_id
  ORDER BY desde_fecha DESC
  LIMIT 1;

  UPDATE personas
  SET dojo_actual_id = dojo_ultimo
  WHERE id = NEW.persona_id;
END;

-- Trigger: actualizar dojo_actual_id al hacer DELETE
CREATE TRIGGER actualizar_dojo_actual_delete
AFTER DELETE ON personas_por_dojo
FOR EACH ROW
BEGIN
  DECLARE dojo_ultimo INT;
  SELECT dojo_id
  INTO dojo_ultimo
  FROM personas_por_dojo
  WHERE persona_id = OLD.persona_id
  ORDER BY desde_fecha DESC
  LIMIT 1;

  UPDATE personas
  SET dojo_actual_id = dojo_ultimo
  WHERE id = OLD.persona_id;
END;

DELIMITER ;


🧲 Paso 2: Crear trigger

DELIMITER $$

CREATE TRIGGER actualizar_graduacion_actual
AFTER INSERT ON historial_graduaciones
FOR EACH ROW
BEGIN
  DECLARE fecha_max DATE;

  -- Obtenemos la última fecha de graduación de la persona
  SELECT MAX(fecha)
  INTO fecha_max
  FROM historial_graduaciones
  WHERE persona_id = NEW.persona_id;

  -- Si la nueva fecha es la más reciente, actualizamos
  IF NEW.fecha = fecha_max THEN
    UPDATE personas
    SET graduacion_actual = NEW.graduacion
    WHERE id = NEW.persona_id;
  END IF;
END;

DELIMITER ;

✅ Paso 1: Trigger AFTER UPDATE

DELIMITER $$

CREATE TRIGGER recalcular_graduacion_actual_update
AFTER UPDATE ON historial_graduaciones
FOR EACH ROW
BEGIN
  DECLARE graduacion_nueva VARCHAR(50);

  SELECT graduacion
  INTO graduacion_nueva
  FROM historial_graduaciones
  WHERE persona_id = NEW.persona_id
  ORDER BY fecha DESC
  LIMIT 1;

  UPDATE personas
  SET graduacion_actual = graduacion_nueva
  WHERE id = NEW.persona_id;
END;

DELIMITER ;

-----------------------------------------------------------------------------------------------------------------------------------
✅ Paso 2: Trigger AFTER DELETE

DELIMITER $$

CREATE TRIGGER recalcular_graduacion_actual_delete
AFTER DELETE ON historial_graduaciones
FOR EACH ROW
BEGIN
  DECLARE graduacion_nueva VARCHAR(50);

  SELECT graduacion
  INTO graduacion_nueva
  FROM historial_graduaciones
  WHERE persona_id = OLD.persona_id
  ORDER BY fecha DESC
  LIMIT 1;

  UPDATE personas
  SET graduacion_actual = graduacion_nueva
  WHERE id = OLD.persona_id;
END;

DELIMITER ;

✅ Paso 2: Trigger AFTER INSERT en personas_por_dojo

DELIMITER $$

CREATE TRIGGER actualizar_dojo_actual_insert
AFTER INSERT ON personas_por_dojo
FOR EACH ROW
BEGIN
  DECLARE fecha_max DATE;
  DECLARE dojo_ultimo INT;

  SELECT dojo_id
  INTO dojo_ultimo
  FROM personas_por_dojo
  WHERE persona_id = NEW.persona_id
  ORDER BY desde_fecha DESC
  LIMIT 1;

  UPDATE personas
  SET dojo_actual_id = dojo_ultimo
  WHERE id = NEW.persona_id;
END;

DELIMITER ;

-----------------------------------------------------------------------------------------------------------------------------------
✅ Paso 3: Trigger AFTER UPDATE en personas_por_dojo

DELIMITER $$

CREATE TRIGGER actualizar_dojo_actual_update
AFTER UPDATE ON personas_por_dojo
FOR EACH ROW
BEGIN
  DECLARE dojo_ultimo INT;

  SELECT dojo_id
  INTO dojo_ultimo
  FROM personas_por_dojo
  WHERE persona_id = NEW.persona_id
  ORDER BY desde_fecha DESC
  LIMIT 1;

  UPDATE personas
  SET dojo_actual_id = dojo_ultimo
  WHERE id = NEW.persona_id;
END;

DELIMITER ;

-----------------------------------------------------------------------------------------------------------------------------------
✅ Paso 4: Trigger AFTER DELETE en personas_por_dojo

DELIMITER $$

CREATE TRIGGER actualizar_dojo_actual_delete
AFTER DELETE ON personas_por_dojo
FOR EACH ROW
BEGIN
  DECLARE dojo_ultimo INT;

  SELECT dojo_id
  INTO dojo_ultimo
  FROM personas_por_dojo
  WHERE persona_id = OLD.persona_id
  ORDER BY desde_fecha DESC
  LIMIT 1;

  UPDATE personas
  SET dojo_actual_id = dojo_ultimo
  WHERE id = OLD.persona_id;
END;

DELIMITER ;