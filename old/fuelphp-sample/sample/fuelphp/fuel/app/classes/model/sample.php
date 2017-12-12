<?php

class Model_Sample
    extends Model
{
    public static $TABLE = "sample";

    /**
     * Get records.
     *
     * @return mixed
     */
    public static function get()
    {
        $data = DB::select()
            ->from(static::$TABLE)
            ->execute()
            ->as_array();

        return $data;
    }
}